package model.bean;

import java.time.LocalDateTime;
import java.util.Date;

public class User {
	private String ID_Account ;
	private String Display_Name;
	private String Username;
	private String Password;
	private String Email_Address;
	private String Phone_Number;
	private Date Birthday;
	private int Gender;
	private String Address;
	private byte[] Avatar;
	private int Role_Account;
	private String Career;
	private String Bio;
	private int TotalPost;
	private int Reported_Quantity;
	private int Status;
	private LocalDateTime DateTime_Locked;
	private String Locked_Ago;
	
	public String getID_Account() {
		return ID_Account;
	}
	public void setID_Account(String iD_Account) {
		ID_Account = iD_Account;
	}
	
	public String getDisplay_Name() {
		return Display_Name;
	}
	public void setDisplay_Name(String display_Name) {
		Display_Name = display_Name;
	}
	
	public String getUsername() {
		return Username;
	}
	public void setUsername(String username) {
		Username = username;
	}
	
	public String getPassword() {
		return Password;
	}
	public void setPassword(String password) {
		Password = password;
	}
	
	public String getEmail_Address() {
		return Email_Address;
	}
	public void setEmail_Address(String email_Address) {
		Email_Address = email_Address;
	}
	
	public String getPhone_Number() {
		return Phone_Number;
	}
	public void setPhone_Number(String phone_Number) {
		Phone_Number = phone_Number;
	}
	
	public Date getBirthday() {
		return Birthday;
	}
	public void setBirthday(Date date) {
		Birthday = date;
	}
	
	public int getGender() {
		return Gender;
	}
	public void setGender(int gender) {
		Gender = gender;
	}
	
	public String getAddress() {
		return Address;
	}
	public void setAddress(String address) {
		Address = address;
	}
	
	public byte[] getAvatar() {
		return Avatar;
	}
	public void setAvatar(byte[] avatar) {
		Avatar = avatar;
	}
	
	public int getRole_Account() {
		return Role_Account;
	}
	public void setRole_Account(int role_Account) {
		Role_Account = role_Account;
	}
	
	public String getCareer() {
		return Career;
	}
	public void setCareer(String career) {
		Career = career;
	}
	
	public String getBio() {
		return Bio;
	}
	public void setBio(String bio) {
		Bio = bio;
	}
	
	public int getTotalPost() {
		return TotalPost;
	}
	public void setTotalPost(int TotalPost) {
		this.TotalPost = TotalPost;
	}
	
	public int getReported_Quantity() {
		return Reported_Quantity;
	}
	public void setReported_Quantity(int reported_Quantity) {
		Reported_Quantity = reported_Quantity;
	}
	
	public int getStatus() {
		return Status;
	}
	public void setStatus(int status) {
		this.Status = status;
	}
	
	public LocalDateTime getDateTime_Locked() {
		return DateTime_Locked;
	}
	public void setDateTime_Locked(LocalDateTime dateTime_Locked) {
		this.DateTime_Locked = dateTime_Locked;
	}
	
	public String getLocked_Ago() {
		return Locked_Ago;
	}
	public void setLocked_Ago(String Locked_Ago) {
		this.Locked_Ago = Locked_Ago;
	}
}
