package model.bean;

import java.util.Date;

public class Account {
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
	public void setBirthday(Date birthday) {
		this.Birthday = birthday;
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
}
