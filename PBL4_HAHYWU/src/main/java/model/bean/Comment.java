package model.bean;

import java.sql.Date;
import java.time.LocalDateTime;

public class Comment {
	private int ID_Comment;
	private int ID_Post;
	private String ID_Commentator;
	private String Name_Commentator;
	private byte[] Avatar_Commentator;
	private String Comment_Content;
	private LocalDateTime Date_Time;
	private byte[] Image; 
	private String Date_ago;
	
	public int getID_Comment() {
		return ID_Comment;
	}
	public void setID_Comment(int iD_Comment) {
		ID_Comment = iD_Comment;
	}
	
	public int getID_Post() {
		return ID_Post;
	}
	public void setID_Post(int iD_Post) {
		ID_Post = iD_Post;
	}
	
	public String getID_Commentator() {
		return ID_Commentator;
	}
	public void setID_Commentator(String iD_Commentator) {
		ID_Commentator = iD_Commentator;
	}
	
	public String getName_Commentator() {
		return Name_Commentator;
	}
	public void setName_Commentator(String name_Commentator) {
		Name_Commentator = name_Commentator;
	}
	
	public byte[] getAvatar_Commentator() {
		return Avatar_Commentator;
	}
	public void setAvatar_Commentator(byte[] avatar_Commentator) {
		Avatar_Commentator = avatar_Commentator;
	}
	
	public String getComment_Content() {
		return Comment_Content;
	}
	public void setComment_Content(String comment_Content) {
		Comment_Content = comment_Content;
	}
	
	public LocalDateTime getDate_Time() {
		return Date_Time;
	}
	public void setDate_Time(LocalDateTime date_Time) {
		Date_Time = date_Time;
	}
	
	public byte[] getImage() {
		return Image;
	}
	public void setImage(byte[] image) {
		Image = image;
	}
	
	public String getDate_ago() {
		return Date_ago;
	}
	public void setDate_ago(String Date_ago) {
		this.Date_ago = Date_ago;
	}
}