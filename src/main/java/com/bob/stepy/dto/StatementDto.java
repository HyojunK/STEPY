package com.bob.stepy.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class StatementDto {
	private String sm_statement;
	private String sm_accountnum;
	private String sm_mid;
	private int sm_cost;
	private Timestamp sm_depositdate;
}
