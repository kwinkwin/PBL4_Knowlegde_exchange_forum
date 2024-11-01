package model.bo;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

import model.bean.Account;
import model.bean.Comment;
import model.bean.Field;
import model.bean.Notification;
import model.bean.NumberCensor;
import model.bean.Post;
import model.bean.User;
import model.dao.GrabDAO;

public class GrabBO {
	GrabDAO grabDAO = new GrabDAO();
	
	public boolean checkCoincidentEmail(String email) {
		return grabDAO.checkCoincidentEmail(email);
	}
	
	public void signupAccount(Account account) {
		
		grabDAO.signupAccount(account);
	}
	
	public boolean checkUsername(String username) {
		return grabDAO.checkUsername(username);
	}
	
	public boolean checkPassword(String username, String password) {
		return grabDAO.checkPassword(username, password);
	}
	
	public boolean checkUserStatus(String username) {
		return grabDAO.checkUserStatus(username);
	}
	
	public void reportUser(String idacc) {
		grabDAO.reportUser(idacc);
	}
	
	public Account getAccountBySigninInfo(String username, String password) {
		return grabDAO.getAccountBySigninInfo(username, password);
	}
	
	public Account getAccountByIDAccount(String idacc) {
		return grabDAO.getAccountByIDAccount(idacc);
	}
	
	public User getUserByIDUser(String idacc) {
		return grabDAO.getUserByIDUser(idacc);
	}
	
	public void updateUser(User user) {
		grabDAO.updateUser(user);
	}
	
	public void changePassword(String idacc, String npw) {
		grabDAO.changePassword(idacc, npw);
	}
	
	public void forgotPassword(String email, String npw) {
		grabDAO.forgotPassword(email, npw);
	}
	
	public void removeAvatar(String idacc) {
		grabDAO.removeAvatar(idacc);
	}
	
	public void changeAvatar(String idacc, byte[] newimg) {
		grabDAO.changeAvatar(idacc, newimg);
	}
	
	/* User's Notification */
	public ArrayList<Notification> showNotication(String ID_Author) {
		return grabDAO.showNotification(ID_Author);
	}
	
	public int countUnseenNoti(String idacc) {
		ArrayList<Notification> notifications = showNotication(idacc);
		int count = 0;
		for (int i = 0; i < notifications.size(); i++)
		{
			if(notifications.get(i).isStatus() == 0) {
				count++;
			}
		}
		return count;
	}
	public Post getPostByIDPost(int ID_Post) {
		return grabDAO.getPostByIDPost(ID_Post);
	}
	
	public void seenNoti(int ID_Notification) {
		grabDAO.seenNoti(ID_Notification);
	}
	
	/* User's Comment */
	public void addComment(Comment comment) {
		grabDAO.addComment(comment);
	}
	
	public void updateCommentQuantity(int ID_Post) {
		grabDAO.updateCommentQuantity(ID_Post);
	}
	
	public ArrayList<Comment> getAllCommentByIDPost(int ID_Post) {
		return grabDAO.getAllCommentByIDPost(ID_Post);
	}
	
	public void deleteComment(int ID_Comment) {
		grabDAO.deleteComment(ID_Comment);
	}
	
	public void deleteNoti(int ID_Post, int ID_Comment) {
		grabDAO.deleteNoti(ID_Post, ID_Comment);
	}
	
	/* Admin */
	public void updateAccount(Account user) {
		grabDAO.updateAccount(user);
	}
	
	public ArrayList<Post> getAllPost(int censor, int ID_Field, String sort) {
		return grabDAO.getAllPost(censor, ID_Field, sort);
	}
	public ArrayList<Field> getAllField() throws Exception, Exception {
		return grabDAO.getAllField();
	}
	public boolean updateCensor(String ID_Post, int censor) throws Exception {
		if(grabDAO.updateCensor(ID_Post, censor) != 0)
		{
			return true;
		}
		return false;
	}
	public boolean addNotification(Notification noti) throws Exception {
		ArrayList<Integer> l = grabDAO.findID_Noti_Max();
		int id;
		if(l.size() == 0)
		{
			id = 1;
		}
		else {
			id = l.get(0).intValue() + 1;
		}
		noti.setID_Notification(id);
		if(grabDAO.addNotification(noti) != 0)
		{
			return true;
		}
		return false;
	}
	
	/* User Post */
	public ArrayList<Post> getUserPost(String ID_User, int censor, int ID_Field, String sort) {
		return grabDAO.getUserPost(ID_User, censor, ID_Field, sort);
	}
	public boolean addField(Field field) throws Exception {
		ArrayList<Integer> l = grabDAO.findID_Field_Max();
		int id;
		if(l.size() == 0)
		{
			id = 1;
		}
		else {
			id = l.get(0).intValue() + 1;
		}
		field.setID_Field(id);
		if(grabDAO.addField(field) != 0)
		{
			return true;
		}
		return false;
	}
	public boolean deleteField(String ID_Field) throws Exception {
		int pf = grabDAO.deletePost_Field(ID_Field);
		if(grabDAO.deleteField(ID_Field) != 0)
		{
			return true;
		}
		return false;
	}
	public boolean newPost(Post p) throws Exception, SQLException {
		ArrayList<Integer> l = grabDAO.findID_Max("post", 1);
		int id;
		if(l.size() == 0)
		{
			id = 1;
		}
		else {
			id = l.get(0).intValue() + 1;
		}
		p.setID_Post(id);
		p.setComment_Quantity(0);
		p.setCensor(0);
		if(grabDAO.newPost(p) != 0)
		{
			if(p.getlistImages().size() != 0)
			{
				ArrayList<Integer> li = grabDAO.findID_Max("post_images", 2);
				
				int idi;
				if(li.size() == 0)
				{
					idi = 1;
				}
				else {
					idi = li.get(0).intValue() + 1;
				}
				
				for(int j=0; j < p.getlistImages().size(); j++)
				{
					p.getlistImages().get(j).setID_Image(idi);
					idi++;
					
				}
				int img = grabDAO.addPost_Images(p.getID_Post(), p.getlistImages());
				if(img == 0 ) return false;
			}
			if(p.getlistFields().size() != 0)
			{
				int f = grabDAO.addPost_Field(p.getID_Post(), p.getlistFields());
				if(f == 0 ) return false;
			}
			return true;
		}
		return false;
	}
	public void updatePost(Post p, int checkimg) throws Exception {
		grabDAO.updatePost(p);
		grabDAO.deleteFieldOfPost(p.getID_Post());
		if(p.getlistFields() != null)
		{
			grabDAO.addPost_Field(p.getID_Post(), p.getlistFields());
		}
		if(checkimg == 0)
		{
			grabDAO.deleteImageOfPost(p.getID_Post());
			if(p.getlistImages() != null)
			{
				ArrayList<Integer> li = grabDAO.findID_Max("post_images", 2);
				
				int idi;
				if(li.size() == 0)
				{
					idi = 1;
				}
				else {
					idi = li.get(0).intValue() + 1;
				}
				
				for(int j=0; j < p.getlistImages().size(); j++)
				{
					p.getlistImages().get(j).setID_Image(idi);
					idi++;
					
				}
				grabDAO.addPost_Images(p.getID_Post(), p.getlistImages());
			}
		}
		if(checkimg == 2)
		{
			if(p.getlistImages() != null)
			{
				ArrayList<Integer> li = grabDAO.findID_Max("post_images", 2);
				
				int idi;
				if(li.size() == 0)
				{
					idi = 1;
				}
				else {
					idi = li.get(0).intValue() + 1;
				}
				
				for(int j=0; j < p.getlistImages().size(); j++)
				{
					p.getlistImages().get(j).setID_Image(idi);
					idi++;
					
				}
				grabDAO.addPost_Images(p.getID_Post(), p.getlistImages());
			}
		}
		if(checkimg == 3)
		{
			grabDAO.deleteImageOfPost(p.getID_Post());
		}
	}
	public void deleteImageOfPost(int ID_Post) throws Exception {
		grabDAO.deleteImageOfPost(ID_Post);
	}
	public NumberCensor getNumberCensor(String ID_Acc) {
		NumberCensor nbCensor = new NumberCensor();
		nbCensor.setTotal(grabDAO.getUserPost(ID_Acc, 5, 0, "DESC").size());
		nbCensor.setCensoring(grabDAO.getUserPost(ID_Acc, 0, 0, "DESC").size());
		nbCensor.setCensored(grabDAO.getUserPost(ID_Acc, 1, 0, "DESC").size());
		nbCensor.setUncensored(grabDAO.getUserPost(ID_Acc, 2, 0, "DESC").size());
		return nbCensor;
	}
	public ArrayList<Post> searchPost(String ID_User, int censor, int ID_Field, String txtsearch, String sort) {
		return grabDAO.searchPost(ID_User, censor, ID_Field, txtsearch, sort);
	}
	public ArrayList<User> searchUser(String txtsearch) {
		return grabDAO.searchUser(txtsearch);
	}
	
	public ArrayList<User> getAllUser(Integer lock, String sort, String search) {
		return grabDAO.getAllUser(lock, sort, search);
	}
	
	public void changeLockStatus(int status, String idacc) {
		grabDAO.changeLockStatus(status, idacc);
	}
}

