package model.dao;

import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;

import org.mindrot.jbcrypt.BCrypt;


import model.bean.Account;
import model.bean.Field;
import model.bean.Image;
import model.bean.Notification;
import model.bean.Post;
import model.bean.User;
import model.bean.Comment;

public class GrabDAO {
	Connection connect;
	public PreparedStatement connectionMySQL(String sql) throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/pbl4", "root", "");
		PreparedStatement preparedStmt = connect.prepareStatement(sql);
		return preparedStmt; 
	}
	
	public boolean checkCoincidentEmail(String email) {
		boolean check = true;
		try {
			String sql = "SELECT * FROM account";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			while(rs.next()) {
			    if(email.equals(rs.getString("Email_Address"))) {
			    	check = false;
			    	break;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public void signupAccount(Account account) {
		try
		{
			String countSql = "SELECT COUNT(*) AS count FROM account WHERE ID_Account LIKE 'US%'";
	        PreparedStatement countStmt = connectionMySQL(countSql);
	        ResultSet rs = countStmt.executeQuery();
	        int count = 0;
	        if (rs.next()) {
	            count = rs.getInt("count");
	        }

	        // Tạo ID mới cho tài khoản
	        String newId = "US" + (count + 1);
	        int roleacc = 1;

	        // Thêm tài khoản mới vào bảng account
	        String insertSql1 = "INSERT INTO account (ID_Account, Display_Name, Username, Password, Email_Address, Phone_Number, Birthday, Gender, Address, Avatar, Role_Account) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt = connectionMySQL(insertSql1);
	        insertStmt.setString(1, newId);
	        insertStmt.setString(2, account.getDisplay_Name());
	        insertStmt.setString(3, account.getUsername());
	        insertStmt.setString(4, account.getPassword());
	        insertStmt.setString(5, account.getEmail_Address());
	        insertStmt.setString(6, null);
	        insertStmt.setDate(7, null);
	        insertStmt.setInt(8, account.getGender());
	        insertStmt.setString(9, null);
	        insertStmt.setBytes(10, null);
	        insertStmt.setInt(11, roleacc);
	        insertStmt.execute();
	        
	        // Thêm tài khoản mới vào bảng user
	        String insertSql2 = "INSERT INTO user (ID_User, Career, Bio, Reported_Quantity, Status) VALUES (?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt2 = connectionMySQL(insertSql2);
	        insertStmt2.setString(1, newId);
	        insertStmt2.setString(2, null);
	        insertStmt2.setString(3, null);
	        insertStmt2.setInt(4, 0);
	        insertStmt2.setInt(5, 0);
	        insertStmt2.execute();
	        
	        if(connect != null) connect.close();
	        if(countStmt != null) countStmt.close();
	        if(insertStmt != null) insertStmt.close();
	        if(insertStmt2 != null) insertStmt2.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public boolean checkUsername(String username) {
		boolean check = false;
		try {
			String sql = "SELECT * FROM account";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			while(rs.next()) {
			    if(username.equals(rs.getString("Username"))) {
			    	check = true;
			    	break;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public boolean checkPassword(String username, String password) {
		boolean check = false;
		try {
			String sql = "SELECT * FROM account WHERE Username = '" + username + "'";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			if(rs.next()) {
			    if(BCrypt.checkpw(password, rs.getString("Password"))) {
			    	check = true;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public Account getAccountBySigninInfo(String username, String password) {
	    Account account = null;
	    try {
	        String sql = "SELECT * FROM account WHERE Username = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, username);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next()) {
	            String hashedPassword = rs.getString("Password");
	            if (BCrypt.checkpw(password, hashedPassword)) {
	                account = new Account();
	                account.setID_Account(rs.getString("ID_Account"));
	                account.setDisplay_Name(rs.getString("Display_Name"));
	                account.setUsername(rs.getString("Username"));
	                account.setPassword(rs.getString("Password"));
	                account.setEmail_Address(rs.getString("Email_Address"));
	                account.setPhone_Number(rs.getString("Phone_Number"));
	                account.setBirthday(rs.getDate("Birthday"));
	                account.setGender(rs.getInt("Gender"));
	                account.setAddress(rs.getString("Address"));
	                account.setAvatar(rs.getBytes("Avatar"));
	                account.setRole_Account(rs.getInt("Role_Account"));
	            }
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    return account;
	}
	
	public Account getAccountByIDAccount(String idacc) {
	    Account account = null;
	    try {
	        String sql = "SELECT * FROM account WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, idacc);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next()) {
                account = new Account();
                account.setID_Account(rs.getString("ID_Account"));
                account.setDisplay_Name(rs.getString("Display_Name"));
                account.setUsername(rs.getString("Username"));
                account.setPassword(rs.getString("Password"));
                account.setEmail_Address(rs.getString("Email_Address"));
                account.setPhone_Number(rs.getString("Phone_Number"));
                account.setBirthday(rs.getDate("Birthday"));
                account.setGender(rs.getInt("Gender"));
                account.setAddress(rs.getString("Address"));
                account.setAvatar(rs.getBytes("Avatar"));
                account.setRole_Account(rs.getInt("Role_Account"));
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    return account;
	}
	
	public User getUserByIDUser(String idacc) {
	    User user = new User();
	    PreparedStatement preStmt;
	    ResultSet rs;
	    try {
	        String sql = "SELECT * FROM account WHERE ID_Account = ?";
	        preStmt = connectionMySQL(sql);
	        preStmt.setString(1, idacc);
	        rs = preStmt.executeQuery();
	        if(rs.next()) {
	        	user.setID_Account(rs.getString("ID_Account"));
	        	user.setDisplay_Name(rs.getString("Display_Name"));
	        	user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setEmail_Address(rs.getString("Email_Address"));
                user.setPhone_Number(rs.getString("Phone_Number"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setGender(rs.getInt("Gender"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getBytes("Avatar"));
                user.setRole_Account(rs.getInt("Role_Account"));
	        }
	        
	        String sql1 = "SELECT * FROM user WHERE ID_User = ?";
	        preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, idacc);
	        rs = preStmt.executeQuery();
	        if(rs.next()) {
	        	user.setCareer(rs.getString("Career"));
	        	user.setBio(rs.getString("Bio"));
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	    return user;
	}
	
	public boolean checkUserStatus(String username) {
		boolean check = true;
		try {
			String iduser = "";
			String sql = "SELECT * FROM account WHERE Username = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
			preStmt.setString(1, username);
			ResultSet rs = preStmt.executeQuery();
			if(rs.next()) {
				iduser = rs.getString("ID_Account");
			}
			String sql1 = "SELECT * FROM user WHERE ID_User = ?";
			preStmt = connectionMySQL(sql1);
			preStmt.setString(1, iduser);
			rs = preStmt.executeQuery();
			if(rs.next()) {
	        	int status = rs.getInt("Status");
	        	if(status == 1) {
	        		check = false;
	        	}
	        }
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public void reportUser(String idacc) {
		try
		{
			int reportedquantity = 0;
			String sql = "SELECT * FROM user WHERE ID_User = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
			preStmt.setString(1, idacc);
			ResultSet rs = preStmt.executeQuery();
			if(rs.next()) {
				reportedquantity = rs.getInt("Reported_Quantity");
	        }
	        String sql1 = "UPDATE user SET Reported_Quantity = ? WHERE ID_User = ?";
	        preStmt = connectionMySQL(sql1);
	        preStmt.setInt(1, reportedquantity + 1);
	        preStmt.setString(2, idacc);
	        preStmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void updateUser(User user) {
		try
		{
	        // Update bang account
	        String sql1 = "UPDATE account SET Display_Name = ?, Email_Address = ?, Phone_Number = ?, Birthday = ?, Gender = ?, Address = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, user.getDisplay_Name());
	        preStmt.setString(2, user.getEmail_Address());
	        preStmt.setString(3, user.getPhone_Number());
	        if(user.getBirthday() != null) {
	        	java.util.Date utilDate = user.getBirthday();
				java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		        preStmt.setDate(4, sqlDate);
	        }
	        else {
	        	preStmt.setDate(4, null);
	        }
	        preStmt.setInt(5, user.getGender());
	        preStmt.setString(6, user.getAddress());
	        preStmt.setString(7, user.getID_Account());
	        preStmt.execute();
	        
	        // Update bang user
	        String sql2 = "UPDATE user SET Career = ?, Bio = ? WHERE ID_User = ?";
	        PreparedStatement preStmt2 = connectionMySQL(sql2);
	        preStmt2.setString(1, user.getCareer());
	        preStmt2.setString(2, user.getBio());
	        preStmt2.setString(3, user.getID_Account());
	        preStmt2.execute();
	        
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	        if(preStmt2 != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void changePassword(String idacc, String npw) {
		try
		{
	        String sql = "UPDATE account SET Password = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, npw);
	        preStmt.setString(2, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void forgotPassword(String email, String npw) {
		try
		{
	        String sql = "UPDATE account SET Password = ? WHERE Email_Address = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, npw);
	        preStmt.setString(2, email);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void removeAvatar(String idacc) {
		try
		{
	        String sql1 = "UPDATE account SET Avatar = null WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void changeAvatar(String idacc, byte[] newimg) {
		try
		{
	        String sql1 = "UPDATE account SET Avatar = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        ByteArrayInputStream bais = new ByteArrayInputStream(newimg);
	        preStmt.setBlob(1, bais);
	        preStmt.setString(2, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Post> getPostByIDAuthor(String ID_Author) {
		ArrayList<Post> result = new ArrayList<Post>();
		try
		{
			String sql = "SELECT * FROM post WHERE ID_Author = ? ORDER BY Date DESC";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, ID_Author);
	        ResultSet rs = preStmt.executeQuery();
		    while(rs.next())
		    {
		    	Post post = new Post();
		    	post.setID_Post(rs.getInt("ID_Post"));
	        	post.setID_Author(rs.getString("ID_Author"));
		        post.setTitle(rs.getString("Title"));
		        post.setCensor(rs.getInt("Censor"));
		        result.add(post);
		    }
		    if(connect != null) connect.close();
		    if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/* User's Notification */
	public ArrayList<Notification> showNotification(String ID_Author) {
		ArrayList<Notification> result = new ArrayList<Notification>();
		ArrayList<Post> posts = getPostByIDAuthor(ID_Author);
		try
		{
			for (int i = 0; i < posts.size(); i++)
			{
				String sql = "SELECT * FROM notification WHERE ID_Post = ? ORDER BY ID_Notification DESC";
				PreparedStatement preStmt = connectionMySQL(sql);
		        preStmt.setInt(1, posts.get(i).getID_Post());
		        ResultSet rs = preStmt.executeQuery();
		        while(rs.next())
			    {
			    	Notification notification = new Notification();
			    	notification.setID_Notification(rs.getInt("ID_Notification"));
			    	String commentatorID = rs.getString("ID_Commentator");
			    	if(commentatorID.equals("null") || commentatorID.trim().isEmpty()) {
				    	notification.setID_Post(posts.get(i).getID_Post());
				    	notification.setName_Post(posts.get(i).getTitle());
				    	notification.setMessage(rs.getString("Message"));
				    	notification.setDate_Time(rs.getTimestamp("Date_Time").toLocalDateTime());
				    	notification.setStatus(rs.getInt("Status"));
				    	result.add(notification);
			    	}
			    	else {
			    		Account account = getAccountByIDAccount(rs.getString("ID_Commentator"));
			    		notification.setID_Commentator(rs.getString("ID_Commentator"));
			    		notification.setName_Commentator(account.getDisplay_Name());
			    		notification.setAvatar_Commentator(account.getAvatar());
			    		notification.setID_Post(posts.get(i).getID_Post());
				    	notification.setName_Post(posts.get(i).getTitle());
				    	notification.setMessage(rs.getString("Message"));
				    	notification.setDate_Time(rs.getTimestamp("Date_Time").toLocalDateTime());
				    	notification.setStatus(rs.getInt("Status"));
				    	result.add(notification);
			    	}
			    }
		        if(connect != null) connect.close();
		        if(preStmt != null) preStmt.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		for(int i=0; i<result.size(); i++)
		{
            LocalDateTime dateTimeFromDB = result.get(i).getDate_Time();
            result.get(i).setDate_ago(getDateAgo(dateTimeFromDB));
		}
		return result;
	}
	
	
	public void seenNoti(int ID_Notification) {
		try
		{
	        String sql = "UPDATE notification SET Status = ? WHERE ID_Notification = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, 1);
	        preStmt.setInt(2, ID_Notification);
	        preStmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* User's Comment */
	public void addComment(Comment comment) {
		try
		{
			String countSql = "SELECT MAX(ID_Comment) AS count FROM comment";
	        PreparedStatement countStmt = connectionMySQL(countSql);
	        ResultSet rs = countStmt.executeQuery();
	        int count = 0;
	        if (rs.next()) {
	            count = rs.getInt("count");
	        }
	        // Tạo ID mới cho cmt
	        int newId = count + 1;

	        // Thêm cmt mới vào bảng comment
	        String insertSql1 = "INSERT INTO comment (ID_Comment, ID_Post, ID_Commentator, Comment, Date_Time) VALUES (?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt = connectionMySQL(insertSql1);
	        insertStmt.setInt(1, newId);
	        insertStmt.setInt(2, comment.getID_Post());
	        insertStmt.setString(3, comment.getID_Commentator());
	        insertStmt.setString(4, comment.getComment_Content());
	        insertStmt.setTimestamp(5, Timestamp.valueOf(comment.getDate_Time()));
	        insertStmt.execute();
	        
	        // Thêm ảnh vào bảng comment_images, nếu cmt đó có ảnh thì thêm DL ảnh đó vào nếu không có ảnh thì set giá trị Image là null
	        String insertSql2 = "INSERT INTO comment_images (ID_Comment, ID_Image, Image) VALUES (?, ?, ?)";
	        PreparedStatement insertStmt2 = connectionMySQL(insertSql2);
	        insertStmt2.setInt(1, newId);
	        insertStmt2.setInt(2, newId);
	        if(comment.getImage() != null) {
	        	ByteArrayInputStream bais = new ByteArrayInputStream(comment.getImage());
		        insertStmt2.setBlob(3, bais);
	        }
	        else {
	        	insertStmt2.setBytes(3, null);
	        }
	        insertStmt2.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Comment> getAllCommentByIDPost(int ID_Post) {
		ArrayList<Comment> result = new ArrayList<Comment>();
		try
		{
			String sql = "SELECT * FROM comment WHERE ID_Post = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Post);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next())
		    {
		    	Comment comment = new Comment();
		    	comment.setID_Comment(rs.getInt("ID_Comment"));
		    	comment.setID_Post(ID_Post);
	    		Account account = getAccountByIDAccount(rs.getString("ID_Commentator"));
	    		comment.setID_Commentator(rs.getString("ID_Commentator"));
	    		comment.setName_Commentator(account.getDisplay_Name());
	    		comment.setAvatar_Commentator(account.getAvatar());
	    		comment.setComment_Content(rs.getString("Comment"));
	    		comment.setDate_Time(rs.getTimestamp("Date_Time").toLocalDateTime());
	    		sql = "SELECT * FROM comment_images WHERE ID_Comment = ?";
		        preStmt = connectionMySQL(sql);
		        preStmt.setInt(1, rs.getInt("ID_Comment"));
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        { 
		        	comment.setImage(rs1.getBytes("Image"));
		        }
		    	result.add(comment);
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
		for(int i=0; i<result.size(); i++)
		{
            LocalDateTime dateTimeFromDB = result.get(i).getDate_Time();
            result.get(i).setDate_ago(getDateAgo(dateTimeFromDB));
		}
		return result;
	}
	
	public int countCommentOfPost(int ID_Post) {
		int count = 0;
		try
		{
			String countSql = "SELECT COUNT(*) AS count FROM comment WHERE ID_Post = ?";
	        PreparedStatement countStmt = connectionMySQL(countSql);
	        countStmt.setInt(1, ID_Post);
	        ResultSet rs = countStmt.executeQuery();
	        
	        if (rs.next()) {
	            count = rs.getInt("count");
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	public void updateCommentQuantity(int ID_Post) {
		try
		{
			int count = countCommentOfPost(ID_Post);
	        String sql = "UPDATE post SET Comment_Quantity = ? WHERE ID_Post = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, count);
	        preStmt.setInt(2, ID_Post);
	        preStmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void deleteComment(int ID_Comment) {
		try
		{
			// Xoa o bang comment_images
	        String sql = "DELETE FROM comment_images WHERE ID_Comment = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Comment);
	        preStmt.execute();
	        // Xoa o bang comment_images
	        String sql1 = "DELETE FROM comment WHERE ID_Comment = ?";
	        PreparedStatement preStmt1 = connectionMySQL(sql1);
	        preStmt1.setInt(1, ID_Comment);
	        preStmt1.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Comment getCommentByIDComment(int ID_Comment) {
		Comment comment = new Comment();
		try
		{
			String sql = "SELECT * FROM comment WHERE ID_Comment = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Comment);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next())
		    {
		    	comment.setID_Comment(rs.getInt("ID_Comment"));
		    	comment.setID_Post(rs.getInt("ID_Post"));
	    		Account account = getAccountByIDAccount(rs.getString("ID_Commentator"));
	    		comment.setID_Commentator(rs.getString("ID_Commentator"));
	    		comment.setName_Commentator(account.getDisplay_Name());
	    		comment.setAvatar_Commentator(account.getAvatar());
	    		comment.setComment_Content(rs.getString("Comment"));
	    		comment.setDate_Time(rs.getTimestamp("Date_Time").toLocalDateTime());
	    		sql = "SELECT * FROM comment_images WHERE ID_Comment = ?";
		        preStmt = connectionMySQL(sql);
		        preStmt.setInt(1, rs.getInt("ID_Comment"));
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        { 
		        	comment.setImage(rs1.getBytes("Image"));
		        }
		        comment.setDate_ago(getDateAgo(rs.getTimestamp("Date_Time").toLocalDateTime()));
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return comment;
	}
	
	public void deleteNoti(int ID_Post, int ID_Comment) {
		try
		{
			Comment comment = getCommentByIDComment(ID_Comment);
			// Xoa o bang notification
	        String sql = "DELETE FROM notification WHERE ID_Post = ? AND ID_Commentator = ? AND Date_Time = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Post);
	        preStmt.setString(2, comment.getID_Commentator());
	        preStmt.setTimestamp(3, Timestamp.valueOf(comment.getDate_Time()));
	        preStmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/* Admin */
	public void updateAccount(Account user) {
		try
		{
			java.util.Date utilDate = user.getBirthday();
			java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
	        // Update bang account
	        String sql1 = "UPDATE account SET Display_Name = ?, Email_Address = ?, Phone_Number = ?, Birthday = ?, Gender = ?, Address = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, user.getDisplay_Name());
	        preStmt.setString(2, user.getEmail_Address());
	        preStmt.setString(3, user.getPhone_Number());
	        preStmt.setDate(4, sqlDate);
	        preStmt.setInt(5, user.getGender());
	        preStmt.setString(6, user.getAddress());
	        preStmt.setString(7, user.getID_Account());
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Post> getAllPost(int censor, int ID_Field, String sort) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	        String sql = "SELECT * FROM post WHERE Censor = '" + censor + "' ORDER BY Date " + sort;
	        PreparedStatement preStmt = connectionMySQL(sql);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getTimestamp(4).toLocalDateTime());
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	post.setListComment(getAllCommentByIDPost(post.getID_Post()));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    for(int i=0; i<listpost.size(); i++)
		{
            LocalDateTime dateTimeFromDB = listpost.get(i).getDate_Post();
            listpost.get(i).setDate_ago(getDateAgo(dateTimeFromDB));
		}
	    return listpost;
	}
	public ArrayList<Field> getFieldOfPost(int ID_Post) throws Exception, SQLException {
		Field field = null;
		ArrayList<Field> listFields = new ArrayList<Field>();
		String sql = "SELECT * FROM post_field WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
    		field = new Field();
    		field.setID_Field(rs.getInt("ID_Field"));
    		listFields.add(field);
        }
        for(int i=0; i<listFields.size(); i++)
        {
        	sql = "SELECT * FROM field WHERE ID_Field = '" + listFields.get(i).getID_Field() + "'";
        	preStmt = connectionMySQL(sql);
        	rs = preStmt.executeQuery();
        	if(rs.next())
        	{
        		listFields.get(i).setName_Field(rs.getString("Name"));
        	}
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return listFields;
	}
	public ArrayList<Image> getImagesOfPost(int ID_Post) throws Exception, SQLException {
		Image image = null;
		ArrayList<Image> listImages = new ArrayList<Image>();
		String sql = "SELECT * FROM post_images WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	image = new Image();
        	image.setID_Image(rs.getInt(2));
        	image.setImage(rs.getBytes(3));
        	listImages.add(image);
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
		return listImages;
	}
	public ArrayList<Field> getAllField() throws Exception, SQLException {
		Field field = null;
		ArrayList<Field> listFields = new ArrayList<Field>();
		String sql = "SELECT * FROM field";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	field = new Field();
        	field.setID_Field(rs.getInt(1));
        	field.setName_Field(rs.getString(2));
        	listFields.add(field);
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return listFields;
	}
	public int updateCensor(String ID_Post, int censor) throws Exception {
		String sql;
		if(censor == 4)
		{
			sql = "UPDATE post SET Censor='" + censor + "' WHERE ID_Post='" + ID_Post + "'";
		}
		else {
			sql = "UPDATE post SET Censor='" + censor + "', Date='" + Timestamp.valueOf(LocalDateTime.now()) + "' WHERE ID_Post='" + ID_Post + "'";
		}
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public ArrayList<Integer> findID_Noti_Max() throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM notification";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString("ID_Notification")));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return l;
	}
	public int addNotification(Notification noti) throws Exception {
		String sql = "INSERT INTO notification VALUE ('" + noti.getID_Notification() + "', '" + noti.getID_Commentator() + "', '" 
						+ noti.getID_Post() + "', '" + noti.getMessage() + "', '" + noti.getDate_Time() + "', '" + noti.isStatus() + "')";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	
	/* User Post */
	public ArrayList<Post> getUserPost(String ID_User, int censor, int ID_Field, String sort) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	        String sql = "SELECT * FROM post WHERE ID_Author = '" + ID_User + "' ORDER BY Date " + sort;
	        PreparedStatement preStmt = connectionMySQL(sql);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	if(censor != 5)
	        	{
	        		if(censor != rs.getInt(8)) continue;
	        	}
				if(censor != 4)
	        	{
	        		if(rs.getInt(8) == 4) continue;
	        	}
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getTimestamp(4).toLocalDateTime());
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
				post.setListComment(getAllCommentByIDPost(post.getID_Post()));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    for(int i=0; i<listpost.size(); i++)
		{
            LocalDateTime dateTimeFromDB = listpost.get(i).getDate_Post();
            listpost.get(i).setDate_ago(getDateAgo(dateTimeFromDB));
		}
	    return listpost;
	}
	
	public int newPost(Post p) throws Exception, SQLException {
		String sql = "INSERT INTO post VALUE (?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement preStmt = connectionMySQL(sql);
		preStmt.setInt(1, p.getID_Post());
		preStmt.setString(2, p.getID_Author());
		preStmt.setString(3, p.getTitle());
		preStmt.setTimestamp(4, Timestamp.valueOf(p.getDate_Post()));
		preStmt.setString(5, p.getContent());
		preStmt.setString(6, p.getHastag());
		preStmt.setInt(7, p.getComment_Quantity());
		preStmt.setInt(8, p.getCensor());
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public int addPost_Images(int ID_Post, ArrayList<Image> l) throws Exception, SQLException {
		String sql;
		PreparedStatement preStmt = null;
		int rs = 0;
		for(int i=0; i<l.size(); i++)
		{
			sql = "INSERT INTO post_images (ID_Post, ID_Image, Image) VALUES (?, ?, ?)";
	        preStmt = connectionMySQL(sql);
	        ByteArrayInputStream bais = new ByteArrayInputStream(l.get(i).getImage());
	        preStmt.setInt(1, ID_Post);
	        preStmt.setInt(2, l.get(i).getID_Image());
	        preStmt.setBlob(3, bais);
	        preStmt.execute();
		}
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public int addPost_Field(int ID_Post, ArrayList<Field> l) throws Exception, SQLException {
		String sql;
		PreparedStatement preStmt = null;
		int rs = 0;
		for(int i=0; i<l.size(); i++)
		{
			sql = "INSERT INTO post_field VALUE ('" + l.get(i).getID_Field() + "', '" + ID_Post + "')";
			preStmt = connectionMySQL(sql);
			rs = preStmt.executeUpdate();
		}
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public ArrayList<Integer> findID_Max(String tablename, int index) throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM " + tablename;
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString(index)));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        preStmt.close();
        return l;
	}
	public Post getPostByIDPost(int ID_Post) {
		Post post = new Post();
		try
		{
			String sql = "SELECT * FROM post WHERE ID_Post = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Post);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next())
		    {
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	sql = "SELECT * FROM account WHERE ID_Account = ?";
		        preStmt = connectionMySQL(sql);
		        preStmt.setString(1, post.getID_Author());
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        { 
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getTimestamp(4).toLocalDateTime());
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	post.setlistFields(getFieldOfPost(post.getID_Post()));
	        	post.setlistImages(getImagesOfPost(post.getID_Post()));
	        	post.setListComment(getAllCommentByIDPost(post.getID_Post()));
	        	post.setDate_ago(getDateAgo(post.getDate_Post()));
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return post;
	}
	public void updatePost(Post p) {
		try
		{
	        String sql1 = "UPDATE post SET Title = ?, Content = ?, Hastag = ? WHERE ID_Post = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, p.getTitle());
	        preStmt.setString(2, p.getContent());
	        preStmt.setString(3, p.getHastag());
	        preStmt.setInt(4, p.getID_Post());
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int deleteFieldOfPost(Integer ID_Post) throws Exception {
		String sql = "DELETE FROM post_field WHERE ID_Post='" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deleteImageOfPost(Integer ID_Post) throws Exception {
		String sql = "DELETE FROM post_images WHERE ID_Post='" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public ArrayList<Post> searchPost(String ID_User, int censor, int ID_Field, String txtsearch, String sort) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	    	String sql = "";
	    	PreparedStatement preStmt;
	    	if(!ID_User.equals(""))
	    	{
	    		sql = "SELECT * FROM post WHERE ID_Author = ? AND (Title LIKE ? OR Content LIKE ? OR Hastag LIKE ?) ORDER BY Date " + sort;
	    		preStmt = connectionMySQL(sql);
	    		preStmt.setString(1, ID_User);
	    	    preStmt.setString(2, "%" + txtsearch + "%");
	    	    preStmt.setString(3, "%" + txtsearch + "%");
	    	    preStmt.setString(4, "%" + txtsearch + "%");
	    	}
	    	else {
	    		sql = "SELECT * FROM post WHERE Censor = ? AND (Title LIKE ? OR Content LIKE ? OR Hastag LIKE ?) ORDER BY Date " + sort;
	    		preStmt = connectionMySQL(sql);
	    		preStmt.setInt(1, censor);
	    	    preStmt.setString(2, "%" + txtsearch + "%");
	    	    preStmt.setString(3, "%" + txtsearch + "%");
	    	    preStmt.setString(4, "%" + txtsearch + "%");
			}
	        
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	if(censor != 5)
	        	{
	        		if(censor != rs.getInt(8)) continue;
	        	}
	        	if(censor != 4)
	        	{
	        		if(rs.getInt(8) == 4) continue;
	        	}
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getTimestamp(4).toLocalDateTime());
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	post.setListComment(getAllCommentByIDPost(post.getID_Post()));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    for(int i=0; i<listpost.size(); i++)
		{
            LocalDateTime dateTimeFromDB = listpost.get(i).getDate_Post();
            listpost.get(i).setDate_ago(getDateAgo(dateTimeFromDB));
		}
	    return listpost;
	}
	
	public ArrayList<User> searchUser(String txtsearch) {
		ArrayList<User> list = new ArrayList<User>();
	    User user = null;
	    PreparedStatement preStmt;
	    ResultSet rs;
	    try {
	        String sql = "SELECT * FROM account WHERE Role_Account = 1 AND Display_Name LIKE ?";
	        preStmt = connectionMySQL(sql);
	        preStmt.setString(1, "%" + txtsearch + "%");
	        rs = preStmt.executeQuery();
	        while(rs.next()) {
	        	user = new User();
	        	user.setID_Account(rs.getString("ID_Account"));
	        	user.setDisplay_Name(rs.getString("Display_Name"));
	        	user.setAvatar(rs.getBytes("Avatar"));
	        	user.setTotalPost(getUserPost(user.getID_Account(), 1, 0, "DESC").size());
	        	list.add(user);
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return list;
	}
	
//	Manage Fields
	public ArrayList<Integer> findID_Field_Max() throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM field";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString("ID_Field")));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        preStmt.close();
        return l;
	}
	public int addField(Field field) throws Exception {
		String sql = "INSERT INTO field VALUE ('" + field.getID_Field() + "', '" + field.getName_Field() + "')";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deletePost_Field(String ID_Field) throws Exception {
		String sql = "DELETE FROM post_field WHERE ID_Field='" + ID_Field + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deleteField(String ID_Field) throws Exception {
		String sql = "DELETE FROM field WHERE ID_Field='" + ID_Field + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	
//	Manage User
	public ArrayList<User> getAllUser(Integer lock, String sort, String search) {
		ArrayList<User> list = new ArrayList<User>();
		User user = null;
		try {
			String sql;
			if(!search.equals(""))
			{
				sql = "SELECT * FROM account WHERE Display_Name LIKE '%" + search + "%' AND Role_Account = 1 ORDER BY Display_Name " + sort;
			}
			else
			{
				sql = "SELECT * FROM account WHERE Role_Account = 1 ORDER BY Display_Name " + sort;
			}
			
			String sql1 = "";
			PreparedStatement preStmt = connectionMySQL(sql);
			PreparedStatement preStmt1;
			ResultSet rs = preStmt.executeQuery(sql);
			ResultSet rs1;
			while(rs.next()) {
				user = new User();
				user.setID_Account(rs.getString("ID_Account"));
				user.setDisplay_Name(rs.getString("Display_Name"));
				user.setAvatar(rs.getBytes("Avatar"));
				user.setTotalPost(getUserPost(user.getID_Account(), 1, 0, "DESC").size());
			    
			    sql1 =  "SELECT * FROM user WHERE ID_User = '" + user.getID_Account() + "'";
			    preStmt1 = connectionMySQL(sql1);
			    rs1 = preStmt1.executeQuery(sql1);
			    if(rs1.next())
			    {
				    user.setReported_Quantity(rs1.getInt("Reported_Quantity"));
				    if(lock != 2) //all
				    {
				    	if(rs1.getInt("Status") != lock)
					    {
					    	continue;
					    }

				    }
				    user.setStatus(rs1.getInt("Status"));
				    if(user.getStatus() == 1)
				    {
				    	LocalDateTime dateTimeFromDB = rs1.getTimestamp("DateTime_Locked").toLocalDateTime();
				    	user.setLocked_Ago(getDateAgo(dateTimeFromDB));
				    }   
			    }
				
			    list.add(user);
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			
		}
		return list;
	}
	
	public void changeLockStatus(int status, String idacc) {
		try
		{
	        String sql = "UPDATE user SET Status = ?, DateTime_locked = ?, Reported_Quantity = 0 WHERE ID_User = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, status);
	        preStmt.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
	        preStmt.setString(3, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDateAgo(LocalDateTime dateTimeFromDB) {
		LocalDateTime now = LocalDateTime.now();
        // Tính khoảng thời gian chênh lệch
        Duration duration = Duration.between(dateTimeFromDB, now);
        long seconds = duration.getSeconds();

        String display;
        if (duration.toDays() < 7) 
        {
        	if (seconds < 5) {
                display = "now";
            } else if (seconds < 60) {
                display = seconds + "s";
            } else if (seconds < 3600) {
                display = duration.toMinutes() + "m";
            } else if (seconds < 86400) {
                display = duration.toHours() + "h";
            } else {
                display = duration.toDays() + "d";
            }
        } else {
            // Nếu khoảng thời gian chênh lệch lớn hơn hoặc bằng 7 ngày, lấy ngày từ cơ sở dữ liệu
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd-yyyy");
            display = dateTimeFromDB.format(formatter);
        }
        return display;
	}
}

