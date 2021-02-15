package com.bob.stepy.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class ResTicketDto {
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
}
