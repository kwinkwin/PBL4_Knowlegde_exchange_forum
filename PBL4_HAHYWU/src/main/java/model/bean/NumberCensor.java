package model.bean;

public class NumberCensor {
	private int Total;
	private int Censoring;
	private int Censored;
	private int Uncensored;
	
	public int getTotal() {
		return Total;
	}
	public void setTotal(int Total) {
		this.Total = Total;
	}
	public int getCensoring() {
		return Censoring;
	}
	public void setCensoring(int Censoring) {
		this.Censoring = Censoring;
	}
	public int getCensored() {
		return Censored;
	}
	public void setCensored(int Censored) {
		this.Censored = Censored;
	}
	public int getUncensored() {
		return Uncensored;
	}
	public void setUncensored(int Uncensored) {
		this.Uncensored = Uncensored;
	}
}
