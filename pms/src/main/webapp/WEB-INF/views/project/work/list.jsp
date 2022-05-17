<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageMaker" value="${dataMap.pageMaker }" />
<c:set var="cri" value="${dataMap.pageMaker.cri }" />
<c:set var="workList" value="${dataMap.workList }" />

<head>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/cloud/cloud.css" />

<style>
h5 {
	margin:0;
}
</style>

</head>
<title>일감 목록</title>
<body>

<section class="content-header">
	<div class="container-fluid">
		<div class="row mb-2">
			<div class="col-sm-6">
				<h1>${prj.prjNm }</h1>
			</div>
			<div class="col-sm-6 d-none d-sm-block">
				<ol class="breadcrumb float-sm-right">
					<li class="breadcrumb-item"><a href="#">${prj.prjNm }</a></li>
					<li class="breadcrumb-item"><a href="#">일감</a></li>
					<li class="breadcrumb-item active">목록</li>
				</ol>
			</div>
		</div>
	</div>
</section>

<!-- Main content -->
<section class="content">
	<div class="card card-secondary card-outline">


		<div class="card-header with-border">
			<button type="button" class="btn btn-primary" onclick="location.href='<%=request.getContextPath()%>/project/work/registForm.do';">생 성</button>
			<div id="keyword" class="card-tools" style="width: 60%">
				<div class="input-group row" style="top:5px;">
					<!-- search bar -->
					<!-- sort num -->
					<select class="form-control col-md-2" name="perPageNum" id="perPageNum" onchange="list_go(1);">
						<option value="10" >정렬개수</option>
						<option value="20" ${cri.perPageNum == 20 ? 'selected':''}>20개씩</option>
						<option value="30" ${cri.perPageNum == 30 ? 'selected':''}>30개씩</option>
						<option value="50" ${cri.perPageNum == 50 ? 'selected':''}>50개씩</option>
					</select>
				
					<!-- search bar -->
					<select class="form-control col-md-2" name="sttCode" id="sttCode" onchange="list_go(1);" style="width:100px;">
						<option value="">상태</option>
						<c:forEach items="${workSttList}" var="workStt">
							<option value="${workStt.code}" ${param.sttCode eq workStt.code ? 'selected' : ''}>${workStt.nm }</option>
						</c:forEach>
					</select>
					<select class="form-control col-md-2" name="ipcrCode" id="ipcrCode" onchange="list_go(1);">
						<option value="">우선순위</option>
						<c:forEach items="${ipcrList}" var="ipcr">
							<option value="${ipcr.code}" ${param.ipcrCode eq ipcr.code ? 'selected' : ''}>${ipcr.nm }</option>
						</c:forEach>
					</select>
					<select class="form-control col-md-2" name="searchType" id="searchType" style="width:100px;">
						<option value="t" ${param.searchType eq 't' ? 'selected' : ''}>제목</option>
						<option value="c" ${param.searchType eq 'c' ? 'selected' : ''}>내용</option>
						<option value="w" ${param.searchType eq 'w' ? 'selected' : ''}>담당자</option>
						<option value="uno" ${param.searchType eq 'uno' ? 'selected' : ''}>상위일감</option>
					</select>

					<!-- keyword -->
					<input class="form-control" type="text" name="keyword" placeholder="검색어를 입력하세요." onkeyup="enterkey()" value="${cri.keyword }" />
					<span class="input-group-append">
						<button class="btn btn-primary" type="button" id="searchBtn" data-card-widget="search" onclick="list_go(1);">
							<i class="fa fa-fw fa-search"></i>
						</button>
					</span> <!-- end : search bar -->
							
				</div>
			</div>
		</div>
		<div class="card-body" style="text-align: center;">
			<div class="row">
				<div class="col-sm-12">
					<table class="table table-bordered table-hover text-nowrap">
						<thead>
							<tr>
								<th style="width: 5%">#</th>
								<th style="width: 7%">일감번호</th>
								<th style="width: 7%">상태</th>
								<th style="width: 7%">우선순위</th>
								<th>제목</th>
								<th style="width: 7%">담당자</th>
								<th style="width: 10%">시작일자</th>
								<th style="width: 10%">종료일자</th>
								<th style="width: 12%">진척도</th>
								<th style="width: 7%">상위일감</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty workList }">
								<tr>
		     						<td colspan="10" class="text-center">
		     							해당 내용이 없습니다.
		     						</td>
		     					</tr>	
				     		</c:if>
							
							<c:if test="${!empty workList }">
								<c:forEach items="${workList }" var="work" varStatus="status">
									
									<jsp:useBean id="now" class="java.util.Date" />
									<fmt:formatDate value="${work.endDt}" pattern="yyyy-MM-dd" var="endDate" />
									<fmt:parseDate value="${endDate }" pattern="yyyy-MM-dd" var="endDateT"/>
									<fmt:parseNumber value="${now.time / (1000*60*60*24) }" var="todayTime" integerOnly="true" />
									<fmt:parseNumber value="${endDateT.time / (1000*60*60*24) }" var="endDateTime" integerOnly="true" />
									
									<tr style="cursor: pointer;"
										<c:if test="${endDateTime - todayTime <= 7 and endDateTime - todayTime > 3 and work.sttCode != 'c'}"> class="table-warning"</c:if>
										<c:if test="${endDateTime - todayTime <= 3 and work.sttCode != 'c'}"> class="table-danger"</c:if>
										data-workNo="${work.workNo }" data-keyword="${work.workTitle }"
									>
										<!-- 목록 카운트 -->
										<td>${status.count }</td>
										<!-- 일감번호 -->
										<td>#${work.workNo }</td>
										<!-- 상태 -->
										<td style="padding:5px; margin:0;">
											<c:choose>
												<c:when test="${work.sttCode eq 'r'}"><h5><span class="badge badge-pill badge-info">요청</span></h5></c:when>
												<c:when test="${work.sttCode eq 'p'}"><h5><span class="badge badge-pill badge-success">진행</span></h5></c:when>
												<c:when test="${work.sttCode eq 'f'}"><h5><span class="badge badge-pill badge-danger">피드백</span></h5></c:when>
												<c:when test="${work.sttCode eq 'c'}"><h5><span class="badge badge-pill badge-primary">완료</span></h5></c:when>
												<c:when test="${work.sttCode eq 'h'}"><h5><span class="badge badge-pill badge-secondary">보류</span></h5></c:when>
											</c:choose>
										</td>
										<!-- 우선순위 -->
										<td>
											<c:choose>
												<c:when test="${work.ipcrCode eq 'l'}"><i class="fa-solid fa-arrow-down"></i>&nbsp;낮음</c:when>
												<c:when test="${work.ipcrCode eq 'u'}"><i class="fa-solid fa-minus" style="color:green"></i>&nbsp;보통</c:when>
												<c:when test="${work.ipcrCode eq 'h'}"><i class="fa-solid fa-arrow-up" style="color:orange"></i>&nbsp;높음</c:when>
												<c:when test="${work.ipcrCode eq 'e'}"><i class="fa-solid fa-land-mine-on" style="color:red"></i>&nbsp;긴급</c:when>
											</c:choose>
										</td>
										<!-- 제목 -->
										<td style="text-align:left;">${work.workTitle }</td>
										<!-- 담당자명 -->
										<td>${work.userNm }</td>
										<!-- 시작일자 -->
										<td><fmt:formatDate value="${work.bgnDt }" pattern="yyyy-MM-dd" /></td>
										<!-- 종료일자 -->
										<td><fmt:formatDate value="${work.endDt }" pattern="yyyy-MM-dd" /></td>
										<!-- 진척도 -->
										<td class="project_progress">
											<div class="progress progress-sm">
												<div class="progress-bar bg-green" role="progressbar" aria-valuenow="${work.workRate }" aria-valuemin="0" aria-valuemax="100" style="width: ${work.workRate }%"></div>
											</div>
											<small> ${work.workRate }% Complete </small>
										</td>
										<td class="text-center">
											<c:if test="${work.upWork != 0}"> #${work.upWork}</c:if>
										</td>
									</tr>
								</c:forEach>
							</c:if>
						</tbody>
					</table>
				</div> <!-- col-sm-12 -->
			</div> <!-- row -->
		</div> <!-- card-body -->
		
		<!-- pagination -->
		<div class="card-footer"> 
			<%@ include file="/WEB-INF/views/common/pagination2.jsp" %>
		</div>

	</div>
	<div class="rightmenu_layer rightmenu_on" style="left: -9999px; top: -99999px; position: absolute; z-index: 1000; visibility: hidden;">
		<ul class="default min_right_ly">
			<li><a class="registIssue" href="#" style="text-indent: 0px;">이슈 등록</a></li>
			<li><a class="goIssue" href="#" style="text-indent: 0px;">이슈 목록보기</a></li>
		</ul>
	</div>
</section>


<form id="jobForm">	
	<input type='hidden' name="page" value="" />
	<input type="hidden" name="perPageNum" value="" />
	
	<input type='hidden' name="sttCode" value="" />
	<input type='hidden' name="ipcrCode" value="" />
	<input type='hidden' name="worker" value="" />
	
	<input type='hidden' name="searchType" value="" />
	<input type='hidden' name="keyword" value="" />
</form>

<script type="text/javascript">
function list_go(page, url) { 
	if (!url) url = "list.do";
	var jobForm = $('#jobForm');
	
	jobForm.find("[name='page']").val(page);
	jobForm.find("[name='perPageNum']").val($('select[name="perPageNum"]').val());
	
	jobForm.find("[name='sttCode']").val($('select[name="sttCode"]').val());
	jobForm.find("[name='ipcrCode']").val($('select[name="ipcrCode"]').val());
	jobForm.find("[name='worker']").val($('select[name="worker"]').val());
	
	jobForm.find("[name='searchType']").val($('select[name="searchType"]').val());
	jobForm.find("[name='keyword']").val($('div.input-group>input[name="keyword"]').val());
	
	jobForm.attr({
		action : url,
		method : 'get'
	}).submit();
}

function enterkey() {
	if (window.event.keyCode == 13) {
		list_go(1);
    }
}
</script>


<script>
window.addEventListener('DOMContentLoaded', onloadWorkList);

function onloadWorkList() {
 	MemberPictureThumb('<%=request.getContextPath()%>');
	<c:if test="${from eq 'registFail' }">
		alert("등록 실패했습니다.");
	</c:if>
	console.log("${open }")
	<c:if test="${open eq '1' }">
		window.close();
		opener.parent.location.reload();
	</c:if>
	
    //Date range picker
	moment.locale('ko'); // 언어를 한국어로 설정함
    $('#rangeDt').daterangepicker({
        locale :{ 
	        format: 'YYYY-MM-DD',
	        applyLabel: "적용",
	        cancelLabel: "닫기",
	        separator: ' ~ ',
	     	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	   		daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"]
        }
    });
}

</script>
<script>
	/* 변수 선언 */
	var card_body = document.querySelector(".card-body");
	var section_content = document.querySelector("section.content");
	var body_table = document.querySelector("table");
	var rightmenu_on = document.querySelector(".rightmenu_on");
	var rightmenuFlag = false;
	
	document.body.addEventListener("click", function(e) {
		if (rightmenu_on.style.visibility != "hidden") {
			rightmenu_on.style.visibility = "hidden";
			rightmenu_on.style.top = "-9999px";
			rightmenu_on.style.left = "-9999px";
		}
	});
	
	body_table.addEventListener("click", function (e) {
		if (rightmenu_on.style.visibility != "hidden") {
			rightmenu_on.style.visibility = "hidden";
			rightmenu_on.style.top = "-9999px";
			rightmenu_on.style.left = "-9999px";
			rightmenuFlag = false;
		} else {
			let workNo = getWorkNo(e);
			work_detail_go(workNo);
		}
	});
	
	body_table.addEventListener("contextmenu", function (e) {
		e.preventDefault();
		if (e.target.tagName == "TD" || e.target.tagName == "TR") {
			displayRightMenu(e, rightmenuFlag);
			setHrefInfo(e.target);
		}
	});
	
	// workNo 가져오는 function
	function getWorkNo(e) {
		if (e.target.closest("tbody")) {
			if (e.target.tagName == "TR") {
				let workNo = e.target.dataset.workno;
				return workNo;
			}
			if (e.target.tagName == "TD") {
				let parentEl = e.target.parentElement;
				let workNo = parentEl.dataset.workno;
				return workNo;
			}
		}
	}
	
	// 우클릭 이벤트로 div 화면 활성
	function displayRightMenu(e, flag) {
		let rect = e.target.getBoundingClientRect();
		let section_rect = section_content.getBoundingClientRect();
		let x = rect.left - section_rect.left + e.offsetX;
		let y = e.pageY;
		if (!flag) {
			$(".rightmenu_on").css({
		        visibility: "visible",
		        top: y,
		        left: x
	        });
			rightmenuFlag = true;
		} else {
			$(".rightmenu_on").css({
				"visibility" : "hidden",
				"top" : "-9999px",
				"left" : "-9999px"
			});
			rightmenuFlag = false;
		}
	}
	
	// 일감 상세보기로 이동
	function work_detail_go(workNo) {
		location.href="<%=request.getContextPath()%>/project/work/detail.do?workNo=" + workNo;
	}
	
	// 우클릭 시 우클릭 메뉴 값 세팅
	function setHrefInfo(eventTarget) {
		let goIssueList = document.querySelector(".goIssue");
		let registIssueGo = document.querySelector(".registIssue");
		
		let keyword = eventTarget.parentElement.dataset.keyword;
		let workNo = eventTarget.parentElement.dataset.workno;
		
		let href = location.href;
		href = href.substring(0, href.indexOf("work"));
		
		let issueListUrl = href + "/issue/list.do?page=1&sttCode=&gradeCode=&searchType=n&keyword="+workNo;
		let issueRegistUrl = href + "/issue/registForm.do?workNo=" + workNo +"&from=workList";
		 
		goIssueList.setAttribute("href", issueListUrl);
		registIssueGo.setAttribute("href", issueRegistUrl);
	}
</script>

 <c:if test="${from eq 'issueRegist' }">
	<script>
		window.onload = function(){
			 //alert("자료를 정상적으로 등록했습니다.");
				Swal.fire({
				  text: '이슈가 정상적으로 등록되었습니다.',
				  icon: 'success',
				  confirmButtonColor: '#007bff',
				  confirmButtonText: '확인'
			}).then((result) => {
				  /* Read more about isConfirmed, isDenied below */
				  if (result.isConfirmed) {
			 		window.location.reload();
				  }
			}); 
		};
	</script>
</c:if>

</body>