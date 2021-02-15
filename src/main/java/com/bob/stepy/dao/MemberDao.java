package com.bob.stepy.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.bob.stepy.dto.FileUpDto;
import com.bob.stepy.dto.MemberDto;
import com.bob.stepy.dto.MemberPaymentDto;
import com.bob.stepy.dto.MemberPostDto;
import com.bob.stepy.dto.MessageDto;
import com.bob.stepy.dto.PostDto;
import com.bob.stepy.dto.PostDto2;
import com.bob.stepy.dto.ResTicketDto;

public interface MemberDao {

	public int duplicationCheck(String tempid);

	public MemberDto getMemeberInfo(String idPreCheck);
	
	public void memberInsert (MemberDto member);

	public String getEncryptizedPass(String m_id);

	public boolean mThumbUpload(FileUpDto fileDto);

	public FileUpDto mGetProfile(String userid);
	
	public void mKakaoThumbUpload(FileUpDto fileDto);

	public void mModifyUserInfo(MemberDto member);
	
	public MessageDto mGetBfMsg(String ms_mid);

	public void mSetMessage(MessageDto msg);
	
	public List<MessageDto> mGetSendList(@Param("smid") String hostid, @Param("page") int pageNum);

	public List<MessageDto> mGetReceiveList(@Param("mid") String hostid, @Param("page") int pageNum);

	public int mCountReceivedMsg(String hostid);
	
	public int mCountSendMsg(String hostid);
	
	public void mUploadAfterView(MessageDto msg);

	public List<MessageDto> mRetrieveByContents(MessageDto msg);

	public List<MessageDto> mRetrieveByUsername(MessageDto msg);

	public void mUpdatePwd(@Param("m_pwd") String m_pwd, @Param("m_id") String m_id );

	public List<FileUpDto> mMyCartItems(String m_id);

	public List<PostDto> mGetLikedPost(@Param("mid") String userid, @Param("page") int num);

	public int mGetWholeLiked(String userid);

	public List<MemberPostDto> mGetMyPostList(String m_id);

	public List<MemberPostDto> mGetMyReplyList(String m_id);

	public List<MemberPaymentDto> mGetPayPendingList(String m_id);

	public List<MemberPaymentDto> mGetPaidList(String m_id);

	public void mUpdateToPaidStatement(Integer resnum);

	
}
