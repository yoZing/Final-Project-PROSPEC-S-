<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<head>
	<!-- fullCalendar -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/bootstrap/plugins/fullcalendar/main.css" />
	<style type="text/css">
	.fc .fc-toolbar.fc-header-toolbar {
	    margin: 0;
	    margin-bottom: .5rem;	
	    padding: 1rem;
	}
	#fc-dom-1 {
	    font-size: 1.3em;
	}
 	.fc-toolbar-chunk button { 
 		display: none;
 	}
/*  	#calendar { */
/*   		height: 450px !important; */
/*    	} */
	/* 아래의 모든 코드는 영역::코드로 사용 */
	.fc-scroller.fc-scroller-liquid-absolute::-webkit-scrollbar {
	    width: 5px;  /* 스크롤바의 너비 */
	}
	
	.fc-scroller.fc-scroller-liquid-absolute::-webkit-scrollbar-thumb {
	    background: #aaa; /* 스크롤바의 색상 */
	    border-radius: 10px;
	}
	
	.fc-scroller.fc-scroller-liquid-absolute::-webkit-scrollbar-track {
	    background: rgba(33, 122, 244, .1);  /*스크롤바 뒷 배경 색상*/
	}
	</style>
</head>
<title>PROSPEC'S</title>
<body>
	<section class="content-header">
		<div class="container-fluid">
			<div class="row mb-2">
				<div class="col-sm-6">
					<h1>Home</h1>
				</div>
			</div>
		</div>
	</section>
	<!-- Main content -->
	<section class="content">
		<div class="row">
			<div class="col-9">
				<div class="row">
					<div class="col-3 d-flex">
						<!-- Default box -->
						<div class="card card-outline card-info w-100">
							<div class="card-header">
								<h3 class="card-title">프로젝트</h3>
								<i class="fas fa-plus float-right pt-1" onclick="location.href='<%=request.getContextPath() %>/prjSetting/registForm.do'" style="color:gray; cursor:pointer"></i>
<!-- 								<i class="fas fa-plus"></i> -->
								<div class="card-tools">
									<%-- <button type="button" class="btn btn-tool" onclick="location.href='<%=request.getContextPath()%>/prjSetting/list.do'">
										<i class="fa-solid fa-magnifying-glass"></i>
									</button> --%>
								</div>
							</div>
							
							<div class="card-body p-2 project">
								<!-- Default box -->
								<div class="card card-outline card-secondary">
									<div class="card-header">
										<h3 class="card-title">참여중</h3>
										
									</div>
									<div class="card-body p-0">
										<table class="table table-hover">
											<tbody>
											
												<c:if test="${empty joinPrjList }">
													<tr>
							     						<td colspan="1" class="text-center">
							     							참여중인 프로젝트가 없습니다.
							     						</td>
							     					</tr>
												</c:if>
												
												<c:if test="${!empty joinPrjList }">
													<c:forEach items="${joinPrjList }" var="joinPrj">
												
														<tr data-prjNo="${joinPrj.prjNo}" style="cursor:pointer">
															<td>
																<a href="<%=request.getContextPath()%>/project/home.do?prjNo=${joinPrj.prjNo}">${joinPrj.prjNm }</a> <i class="fa-solid fa-gear float-right pt-1" onclick="modifyForm_go('${joinPrj.prjNo}')" style="color:gray; cursor:pointer"></i>
															</td>
														</tr>
													
													</c:forEach>
												</c:if>
												
											</tbody>
										</table>
									</div>
								</div>
								
<!-- 								<div class="card card-outline card-secondary"> -->
<!-- 									<div class="card-header"> -->
<!-- 										<h3 class="card-title">팀</h3> -->
<!-- 									</div> -->
<!-- 									<div class="card-body p-0"> -->
<!-- 										<table class="table table-hover"> -->
<!-- 											<tbody> -->
											
<%-- 												<c:if test="${empty teamPrjList }"> --%>
<!-- 													<tr> -->
<!-- 							     						<td colspan="1" class="text-center"> -->
<!-- 							     							진행중인 프로젝트가 없습니다. -->
<!-- 							     						</td> -->
<!-- 							     					</tr> -->
<%-- 												</c:if> --%>
												
<%-- 												<c:if test="${!empty teamPrjList }"> --%>
<%-- 													<c:forEach items="${teamPrjList }" var="teamPrj"> --%>
<%-- 														<tr data-prjno="${teamPrj.prjNo}" style="cursor:pointer"> --%>
<!-- 															<td> -->
<%-- 																<a href="<%=request.getContextPath()%>/project/home.do?prjNo=${teamPrj.prjNo}">${teamPrj.prjNm }</a> <i class="fa-solid fa-gear float-right pt-1" onclick="modifyForm_go('${teamPrj.prjNo}')" style="color:gray; cursor:pointer"></i> --%>
<!-- 															</td> -->
<!-- 														</tr> -->
<%-- 													</c:forEach> --%>
<%-- 												</c:if> --%>
												
<!-- 											</tbody> -->
<!-- 										</table> -->
<!-- 									</div> /.card-body -->

<!-- 								</div> /.card -->
							</div>
							
							
						</div>
					</div>
					<div class="col-9">
						<div class="card card-outline card-info">
							<div class="card-header">
								<h3 class="card-title">최근 이슈</h3>
								<div class="card-tools">
									<!-- <button type="button" class="btn btn-tool"
										onclick="projectList_go()">
										<i class="fa-solid fa-magnifying-glass"></i>
									</button> -->
								</div>
							</div>
							<div class="card-body p-3">
								<div class="card-body p-3">
									<c:if test="${empty issueList }">
										<div class="post">
											<div class="user-block mb-2">
												<span>등록된 이슈가 없습니다.</span>
											</div>
										</div>
									</c:if>
									<c:if test="${!empty issueList}">
										<c:forEach items="${issueList }" var="issue">
											<div class="post">
												<div class="user-block mb-2">
													<img class="img-circle img-bordered-sm manPicture" data-id="${issue.issueRegister }" style="display:block;width:40px;height:40px;margin:0 auto;"></img>
													<span class="username"> 
														<a href="<%=request.getContextPath()%>/project/issue/detail.do?prjNo=${issue.prjNo}&issueNo=${issue.issueNo }">${issue.title }</a>
													</span> 
													<span class="description">
														작성자: ${issue.userNm } | [<fmt:formatDate value="${issue.regDt }" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>]
													</span>
												</div>
													<p style="font-size:14px" class="mb-1">
														${issue.content }
													</p>
													<small class="description">
														<b>${issue.prjNm }</b>
													</small>
											</div>
										</c:forEach>
									</c:if>	
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- /.card-body -->
				<div class="col-12 p-0">
					<div class="card card-outline card-info">
						<div class="card-header">
							<h3 class="card-title">내 일감</h3>
							<i class="nav-icon fas fa-search float-right pt-1" onclick="location.href='<%=request.getContextPath() %>/myPage/myworkDash.do'" style="color:gray; cursor:pointer"></i>
							
							<div class="card-tools">
								<!-- <button type="button" class="btn btn-tool"
									onclick="projectList_go()">
									<i class="fa-solid fa-magnifying-glass"></i>
								</button> -->
							</div>
						</div>
						<div class="card-body table-responsive p-0" style="text-align: center;">
							<table class="table table-hover text-nowrap">
								<thead>
									<tr>
										<th style="width:5%">#</th>
										<th style="width:15%">프로젝트명</th>
										<th style="width:7%">일감번호</th>
										<th style="width:7%">상태</th>
										<th style="width:7%">우선순위</th>
										<th>제목</th>
										<th style="width:10%">담당자</th>
										<th style="width:10%">진척도</th>
										<th style="width:15%">종료일자</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${empty workList }">
										<tr>
				     						<td colspan="9" class="text-center">
				     							참여중인 프로젝트가 없습니다.
				     						</td>
				     					</tr>
									</c:if>
									
									<c:if test="${!empty workList }">
										<c:forEach items="${workList }" var="work" end="4" varStatus="status">
											<jsp:useBean id="now" class="java.util.Date" />
											<fmt:formatDate value="${work.endDt}" pattern="yyyy-MM-dd" var="endDate" />
											<fmt:parseDate value="${endDate }" pattern="yyyy-MM-dd" var="endDateT"/>
											<fmt:parseNumber value="${now.time / (1000*60*60*24) }" var="todayTime" integerOnly="true" />
											<fmt:parseNumber value="${endDateT.time / (1000*60*60*24) }" var="endDateTime" integerOnly="true" />
											
											<tr <c:if test="${endDateTime - todayTime <= 7 and endDateTime - todayTime > 3 and work.sttCode != 'c'}"> class="table-warning"</c:if>
												<c:if test="${endDateTime - todayTime <= 3 and work.sttCode != 'c'}"> class="table-danger"</c:if>
											 		onclick="location.href='<%=request.getContextPath() %>${work.workUrl}&from=dashboard'" style="cursor:pointer">
												<td>${status.count}</td>
												<td>${work.prjNm }</td>
												<td>#${work.workNo }</td>
												<td>
													<c:choose>
														<c:when test="${work.sttCode eq 'r'}"><h5><span class="badge badge-pill badge-info">요청</span></h5></c:when>
														<c:when test="${work.sttCode eq 'p'}"><h5><span class="badge badge-pill badge-success">진행</span></h5></c:when>
														<c:when test="${work.sttCode eq 'f'}"><h5><span class="badge badge-pill badge-danger">피드백</span></h5></c:when>
														<c:when test="${work.sttCode eq 'c'}"><h5><span class="badge badge-pill badge-primary">완료</span></h5></c:when>
														<c:when test="${work.sttCode eq 'h'}"><h5><span class="badge badge-pill badge-secondary">보류</span></h5></c:when>
													</c:choose>
												</td>	
												<td>
													<c:choose>
														<c:when test="${work.ipcrCode eq 'l'}"><i class="fa-solid fa-arrow-down"></i>&nbsp;</c:when>
														<c:when test="${work.ipcrCode eq 'u'}"><i class="fa-solid fa-minus" style="color:green"></i>&nbsp;</c:when>
														<c:when test="${work.ipcrCode eq 'h'}"><i class="fa-solid fa-arrow-up" style="color:orange"></i>&nbsp;</c:when>
														<c:when test="${work.ipcrCode eq 'e'}"><i class="fa-solid fa-land-mine-on" style="color:red"></i>&nbsp;</c:when>
													</c:choose>
												</td>
												<td style="text-align:left;">${work.workTitle }</td>
												<td>${work.userNm }</td>
												<td>
													<c:choose>
														<c:when test="${work.workRate >= 80 }"><span class="badge bg-success">${work.workRate }%</span></c:when>
														<c:when test="${work.workRate >= 60 and work.workRate < 80}"><span class="badge bg-primary">${work.workRate }%</span></c:when>
														<c:when test="${work.workRate >= 30 and work.workRate < 60}"><span class="badge bg-warning">${work.workRate }%</span></c:when>
														<c:when test="${work.workRate < 30}"><span class="badge bg-danger">${work.workRate }%</span></c:when>
													</c:choose>
												</td>
												<td><fmt:formatDate value="${work.endDt }" pattern="yyyy-MM-dd" /></td>
					     					</tr>
				     					</c:forEach>
									</c:if>
								
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<div class="col-3">
				<!-- Default box -->
				<div class="card card-outline card-info">
					<div class="card-header">
						<h3 class="card-title"><a href="<%=request.getContextPath()%>/myPage/dash.do">일정</a></h3>
<%-- 						<h3 class="card-title"><a href="<%=request.getContextPath()%>/myPage/calendar/main.do">일정</a></h3> --%>
						<div class="card-tools">
							<!-- <button type="button" class="btn btn-tool"
								onclick="projectList_go()">
								<i class="fa-solid fa-magnifying-glass"></i>
							</button> -->
						</div>
					</div>
					<div class="card-body p-2" >
						<div class="pb-3" id="calendar"></div>
						<div id="sched" class="form-control mb-2" style="font-size: 1em;"></div>
						<div id="forPrint" style="max-height: 300px;overflow: auto;"></div>
					</div>
					<!-- /.card-body -->
				</div>
				<!-- /.card -->
			</div>

		</div>
	</section>
	
	 <!-- fullCalendar 2.2.5 -->
    <script src="<%=request.getContextPath()%>/resources/bootstrap/plugins/fullcalendar/main.js"></script>
    
<script>
let datas = {};
window.addEventListener('DOMContentLoaded', onloadMemberList);
function onloadMemberList() {
 	MemberPictureThumb('<%=request.getContextPath()%>');
}


window.addEventListener('DOMContentLoaded', mainDashBoard);

function mainDashBoard() {
	
	var Calendar = FullCalendar.Calendar;
    var Draggable = FullCalendar.Draggable;

    var calendarEl = document.getElementById('calendar');
	 
	/* initialize the external events
    -----------------------------------------------------------------*/
   function ini_events(ele) {
     ele.each(function () {

       // create an Event Object (https://fullcalendar.io/docs/event-object)
       // it doesn't need to have a start or end
       var eventObject = {
         title: $.trim($(this).text()) // use the element's text as the event title
       }

       // store the Event Object in the DOM element so we can get to it later
       $(this).data('eventObject', eventObject)

       // make the event draggable using jQuery UI
       $(this).draggable({
         zIndex        : 1070,
         revert        : true, // will cause the event to go back to its
         revertDuration: 0  //  original position after the drag
       })

     });
     
     
   } // ini_event
	
   displayDate();
   
	/* ADDING EVENTS */
	var currColor = '#3c8dbc' //Red by default
	
		var calendar = new Calendar(calendarEl, {
	  	      headerToolbar: {
//	   	        left  : 'prev,next today',
//	   	        center: 'title',
//	   	        right : 'dayGridMonth,timeGridWeek,timeGridDay'
	  	      },
	  	      height : 500,
	  	      themeSystem: 'bootstrap',
	  	      //Random default events
	  	      events: datas,
		      	  eventClick: function(data) {
			    	    data.jsEvent.preventDefault(); // don't let the browser navigate
			    	    var sched = "";
				    	  if(formatDate(data.event.start) == getToday()) {
					    	  sched ="<b> 오늘의 일정</b>";
				    	  } else {
					    	  sched = "<b>"+ formatDate(data.event.start) + " 의 일정</b>";
				    	  }
				    	  document.getElementById("sched").innerHTML = sched;
			    	    clickDate(formatDate(data.event.start));
//			    	    if (data.event.url) {
//			    	    	window.open(data.event.url , '상세 보기' , "top=210,left=570,width=800,height=700"  );
//			    	        return false;
//			    	    }
			      },
			      dateClick: function(info) {
			    	  console.log(info.dateStr);
			    	  var sched = "";
			    	  if(info.dateStr == getToday()) {
				    	  sched ="<b> 오늘의 일정 </b>";
			    	  } else {
				    	  sched = "<b>"+info.dateStr + " 의 일정</b>";
			    	  }
			    	  document.getElementById("sched").innerHTML = sched;
			    	  clickDate(info.dateStr);
			      },
	  	      editable  : false,
	  	      droppable : false, // this allows things to be dropped onto the calendar !!!
	  	      drop      : function(info) {
	  	      },
	  	      eventDrop: function (info) {
	  	    	  modify(info);
			      }, // eventDrop
			      eventResize: function (info) {
			    	  modify(info);
	  		  } // eventResize
	  	});
		
		
		
		$(calendarEl).find(".fc-scroller-harness .fc-scroller").css({"overflow":"auto"});
		$(calendarEl).find(".fc-col-header").css({"width":"calc(100% - 5px)"});
		$(calendarEl).find(".fc-daygrid-body.fc-daygrid-body-unbalanced").css({"width":"100%"});
		$(calendarEl).find(".fc-scrollgrid-sync-table").css({"width":"100%"});
	
		start();
		
		calendar.render();
// 		calendar.render();
		
		
		
			
		function start() {
			 sched = "<b> 오늘의 일정</b>";
	    	 document.getElementById("sched").innerHTML = sched;
			clickDate(getToday());
			
		
		}
	
	
} // onload

</script>
    
    
<script>

window.addEventListener('DOMContentLoaded', mainDashboard);

function mainDashboard() {
	// 사진 넣기
	MemberPictureThumb('<%=request.getContextPath() %>');
	
	Handlebars.registerHelper({
		"prettifyDate":function(timeValue){ //Handlbars에 날짜출력함수 등록
//	 		var dateObj=new Date(timeValue);
//	 		var year=dateObj.getFullYear();
//	 		var month=dateObj.getMonth()+1;
//	 		var date=dateObj.getDate();
			return new Date(timeValue).format("yyyy-MM-dd");
		},
		"codeKey":function(num){
			if(num == "1") return '회사 일정';
			if(num == "2") return '개인 일정';
			if(num == "3") return '프로젝트 일정';
		},
		"color":function(num){
			if(num == "1") return '#52915e';
			if(num == "2") return '#8fc7cb';
			if(num == "3") return '#eec44b';
		}
		
	});
	
	$(".fc-event-title-container").mouseover(function(){$(this).css("cursor", "pointer");})
	
}
</script>

<script>
function clickDate(date) {
	 
	 dateJson = {};
	 dateJson.date = date; 
	 
	 var target = $("#forPrint");
	 
	 $.ajax({
	        url        :   "<%=request.getContextPath()%>/dashboard/date",
	        type        :   "post",
	        contentType :   "application/json; charset=UTF-8",
	        dataType    :   "json",
	         data       :   JSON.stringify(dateJson),
	        success     :   function(data){
//	        	var dataStr = JSON.stringify(data );
//	        	console.log(dataStr);
//	        	printData(dataStr,$("#forPrint"),$("#date-template"));
				if(data.length == 0) {
					var nullCheck = "<div class='m-2' style='color:#6c757d; background-color:#fffadf; text-align: center;'> 일정이 없습니다.</div>";
		     	    document.getElementById("forPrint").innerHTML = nullCheck;
				} else {
			        printData(data,$("#forPrint"),$("#date-template"));
				}
  	    	},
	        error       :   function(request, status, error){
	        	alertE("서버에 문제가 있습니다.");
	        }
	});
	
}

function displayDate() {
	
	dateJson = {};
	dateJson.date = getToday();
	
	 $.ajax({
	        url        :   "<%=request.getContextPath()%>/dashboard/display",
	        type        :   "post",
	        contentType :   "application/json; charset=UTF-8",
	        dataType    :   "json",
	        async       :    false,
	         data       :   JSON.stringify(dateJson),
	        success     :   function(data){
				datas = data;
	    	},
	        error       :   function(request, status, error){
	        	alertE("서버에 문제가 있습니다.");
	        }
	});
	
}

</script>

<script>
function printData(scheduleList,target,templateObject){
	var template=Handlebars.compile(templateObject.html());
	var html = template(scheduleList);	
// 	target.html("");
	target.html(html);
}

function getToday(){
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);
	
    return year + "-" + month + "-" + day;
}

function formatDate(date) {
	
	var d = new Date(date), month = '' + (d.getMonth() + 1), day = '' + d.getDate(), year = d.getFullYear();
	
	if (month.length < 2) month = '0' + month;
	if (day.length < 2) day = '0' + day;

	return [year, month, day].join('-');
}

</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
<script type="text/x-handlebars-template"  id="date-template" >
{{#each .}}
	<div class="card card-outline card-secondary collapsed-card">
		<div class="card-header">
			<h3 class="card-title"><b>{{title}}</b> </h3> <span class="badge " style='color:white; background-color:{{color keyCode}}; margin-left:20px;'>{{codeKey keyCode}}</span>
			<div class="card-tools">
				<button type="button" class="btn btn-tool"
					data-card-widget="collapse">
					<i class="fas fa-plus"></i>
				</button>
			</div>
		</div>
		<div class="card-body">{{content}}</div>
		<div class="card-body"><b>{{prettifyDate bgnDt}} ~ {{prettifyDate endDt}}</b></div>
	</div>
{{/each}}
</script>

<script>

function modifyForm_go(prjNo) {
	location.href="<%=request.getContextPath() %>/prjSetting/modifyForm.do?prjNo=" + prjNo
}

// 프로젝트 이동 이벤트
 let project_div = document.querySelector(".project");
 project_div.addEventListener("click", function (e) {
	 
	 if (e.target.tagName == "TD") {
		 projectDetail(e.target.parentElement);
	 }
 });
function projectDetail(target) {
	let prjNo = target.dataset.prjno;
	location.href='<%=request.getContextPath()%>/project/home.do?prjNo=' + prjNo;
	
}

</script>



</body>