package com.bob.stepy.dto;

import java.sql.Date;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class ResTicketDto {
	private int res_num;
	private Date res_date;
	private String res_plnum;
	private String res_mid;
	private Date res_checkindate;
	private Date res_checkoutdate;
	private int res_qty;
	private int res_status;
}
