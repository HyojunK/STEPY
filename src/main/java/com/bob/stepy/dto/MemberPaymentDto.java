package com.bob.stepy.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class MemberPaymentDto {

	private int res_num;
	private Date res_date;
	private int res_plnum;
	private String res_mid;
	private String res_name;
	private String res_phone;
	private String res_checkindate;
	private String res_checkoutdate;
	private int res_qty;
	private int res_status;
	private String pl_cnum;
	private int pl_num;
	private String pl_name;
	private int pl_price;
	private int pl_person;
	private int pl_qty;
	private String pl_text;
	private String s_name;
	private String f_sysname;
	
}
