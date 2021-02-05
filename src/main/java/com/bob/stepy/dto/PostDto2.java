package com.bob.stepy.dto;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class PostDto2 {
	private int pnum;
	private String ptitle;
	private String pcontents;
	private String pcategory;
	private int pview;
	private int plike;
	private int preport;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Timestamp pdate;
	private String pmid;
}
