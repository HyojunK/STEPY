package com.bob.stepy.dao;

import java.util.List;

import com.bob.stepy.dto.FileUpDto;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.MessageDto;

public interface MemberDao {

	public int duplicationCheck(String tempid);

	public MemberDto getMemeberInfo(String idPreCheck);
	
	public void memberInsert (MemberDto member);

	public String getEncryptizedPass(String m_id);

	public boolean mThumbUpload(FileUpDto fileDto);

	public FileUpDto mGetProfile(String userid);
	
	public void mKakaoThumbUpload(FileUpDto fileDto);

	public MessageDto mGetBfMsg(String ms_mid);

	public void mSetMessage(MessageDto msg);
	
	public List<MessageDto> mGetSendList(String ms_smid);

	public List<MessageDto> mGetReceiveList(String hostid);

	public void mUploadAfterView(MessageDto msg);
	
}
