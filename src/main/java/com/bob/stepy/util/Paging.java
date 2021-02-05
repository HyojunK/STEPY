package com.bob.stepy.util;

import lombok.extern.java.Log;

//페이징 처리 클래스
@Log
public class Paging {
	private int maxNum;//전체 글 개수
	private int pageNum; //현재 페이지 번호
	private int listCnt;//페이지당 보여줄 글 개수
	private int pageCnt;
	//페이징 버튼 영역에서 보여질 페이지번호의 개수 1,2,3 or 1,2,3,4,5,6,..,10 등
	private String listName; //목록 페이지의 이름(종류)

	//생성자를 통해 초기 필수 데이터 저장 (컨트롤러,서비스에서 준 설정값들을 세트)
	public Paging (int maxNum, int pageNum, int listCnt, int pageCnt, String listName) {
		this.maxNum=maxNum;
		this.pageNum=pageNum;
		this.listCnt=listCnt;
		this.pageCnt=pageCnt;
		this.listName=listName;
	}

	//페이징 처리
	public String makePaing() {
		numbers();
		log.info("한 페이지에서 보여줄 글 수 listCnt : "+listCnt +"(서비스 클래스에서 정했음)");

		//전체 페이지 개수에 따라 경우의 수가 달라짐
		int totalPage = (maxNum % listCnt > 0) ?
						maxNum/listCnt + 1 :
						maxNum/listCnt;
		//EX)글 44개, 한 페이지에 10개를 보여준다면 %==4 T, 4+1페이지가 됨 (T)
		//글이 50개, 한 페이지에 10개를 보여준다면 %==0 F, 5페이지로 결정됨
		//100개 > % == 0 F, 10페이지
		log.info("총 페이지 수 totalPage : "+totalPage);

		//현재 페이지가 속해있는 그룹 번호
		int curGroup = (pageNum % pageCnt > 0) ?
				pageNum/pageCnt + 1 :
				pageNum/pageCnt;
		//페이지 10개를 보여준다는 전제조건의 경우 (pageCnt=10)
		//1번 페이지의 경우 1 % 10>0 T = curGroup = 0+1 = 그룹 1
		//5번 페이지의 경우 5 % 10>0 T = 0+1 = 그룹 1
		//20번 페이지의 경우 20%10>0 F > 2, 그룹 2
		//25번 페이지의 경우 25%10>0 T > 2, 그룹 2
		//10N마다 조건식이 F가 되며 다음 그룹이 시작 됨
		log.info("현재 페이지 번호 pageNum : "+pageNum);
		log.info("현재 페이지의 소속 그룹 curGroup : "+curGroup);

		//스트링 버퍼 임포트
		//이전,페이지 버튼들,다음을 모두 이어붙인 단일 문장으로 붙이기 위함
		StringBuffer sb = new StringBuffer();

		//현재 그룹(1~10 페이지 묶음 등)의 시작 페이지 번호 (1,11,21,..)
		int start = (curGroup * pageCnt) - (pageCnt-1);
		//1~10페이지의 그룹1의 경우 1*10 - 10-1 = 10-9 = '1'로 시작
		//31~40의 그룹4의 경우, 4*10 - 10-1 = 40-9 = '31'로 시작
		log.info("페이지의 시작 번호 start : "+start);

		//현재 그룹의 끝 페이지 번호
		int end =  (curGroup * pageCnt >= totalPage) ?
				totalPage : curGroup * pageCnt;
		//한번에 10페이지, 글은 총 100개인 경우 totalPage=10
		//1번 그룹(1~10)의 경우 1*10 >= 10 T >> 10으로 끝나는 그룹
		//7번 그룹(61~70)의 경우 7*10 >= 10 T >> 
		log.info("페이지의 끝 번호 end : "+end);

		//이전과 다음 버튼, 두 버튼 사이의 페이지 번호 처리
		//[이전] 1 2 3 4 5 [다음]
		//페이지는 총 12페이지, 한 그룹에 5 페이지를 예시로 함
		//1~5,6~10,11~12

		//[이전] 버튼 처리 (그룹 2부터 나타나야 함)
		//시작 페이지가 1이 아닌, 최소한 그룹2 부터의 경우
		//이전 그룹으로 돌아가는 '이전' 버튼이 필요, 스트링버퍼로 링크 생성
		//start = 1,6,11 >> 링크 대상은 1,6이 되어야 함
		if (start != 1) {
			sb.append("<a class='pno' href='" + listName +
					"?pageNum=" + (start - 1) + "'>");
			sb.append("&nbsp;이전&nbsp;");
			sb.append("</a>");
			//<a class='pno' href="list?pageNum5'>이전</a>와 같음
		}

		for (int i = start; i <= end; i++) {
			if(pageNum != i) {
				//페이지 이동을 위한 링크를 걸어줌
				//스트링은 완성된 형태이므로 간섭할 때마다 새로 생성
				//어펜드로 변형을 주면 신규 생성이 아닌 '붙이기'로 늘려감
				sb.append("<a class='pno' href='"+listName+
						"?pageNum="+i+"'>");
				sb.append("&nbsp;"+i+"&nbsp;</a>");
				//

			}
			else {
				//pageNum==i, 현재 페이지로 판단, 링크를 걸지 않음
				sb.append("<font class='pno' style='color:red;'>");
				sb.append("&nbsp;"+i+"&nbsp;</font>");
			}
			//현재 보고있는 페이지가 7번 페이지인 경우 (그룹 1 (1~10))
			//<a class='pno' href='list?pageNum=6'>6</a>
			//start6,7,8,9,end10을 반복해 출력하게 됨
		}//사이 번호 처리 for 끝

		//[다음]버튼 처리 (이전 버튼과 반대로 마지막 그룹을 제외한 모든 그룹에 보여야 함)
		//end가 totalPage와 같다면
		//마지막 페이지가 현재 페이지 그룹에 있으므로
		//다음 그룹으로 넘어갈 필요가 없는 것으로 판단 가능
		if (end != totalPage) {
			sb.append("<a class='pno' href='" + listName +
					"?pageNum=" + (end + 1) + "'>");
			sb.append("&nbsp;다음&nbsp;</a>");
			//1~5페이지의 그룹1의 경우 end=5
			//다음페이지 start=6 이므로 end+1을 대상으로
			//이동하면 다음 그룹의 start로 이동하는 효과가 됨
		}//다음 버튼 처리 if 끝

		//어펜드로 추가되어가면서 쌓인 문자열 조각들을 하나로 합쳐 완성된 문자열로 취급
		return sb.toString();
	}//makePaging 메소드 끝

	public void numbers() {
		System.out.println("총 게시글 수 maxNum : "+maxNum+"\n"
				+"현재 페이지 pageNum : "+pageNum+"\n"
				+"한 페이지에서 보여줄 글 수 listCnt : "+listCnt+"\n"
				+"한 페이지 그룹의 페이지 수 pageCnt : "+pageCnt+"\n"
				+"현재 게시판 리스트의 이름 listName : "+listName);
	}



}//페이징 클래스 끝
