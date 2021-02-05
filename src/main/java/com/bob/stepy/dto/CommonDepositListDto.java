package com.bob.stepy.dto;

import lombok.Data;

@Data
public class CommonDepositListDto {
	private String cd_num;
	private String cd_mid;
	private String cd_accountnum;
	private int cd_plannum;
	private int cd_neededcost;
	private int cd_accmcost;
}
