$PBExportHeader$w_sal_05080.srw
$PBExportComments$수주,할당 미처리 자동집계
forward
global type w_sal_05080 from window
end type
type st_mes from statictext within w_sal_05080
end type
type st_nexttime from statictext within w_sal_05080
end type
type st_nextdate from statictext within w_sal_05080
end type
type st_broken from statictext within w_sal_05080
end type
type st_failures from statictext within w_sal_05080
end type
type st_lasttime from statictext within w_sal_05080
end type
type st_lastdate from statictext within w_sal_05080
end type
type st_what from statictext within w_sal_05080
end type
type st_jobno from statictext within w_sal_05080
end type
type st_13 from statictext within w_sal_05080
end type
type st_12 from statictext within w_sal_05080
end type
type st_11 from statictext within w_sal_05080
end type
type st_10 from statictext within w_sal_05080
end type
type st_9 from statictext within w_sal_05080
end type
type st_8 from statictext within w_sal_05080
end type
type st_7 from statictext within w_sal_05080
end type
type st_6 from statictext within w_sal_05080
end type
type st_5 from statictext within w_sal_05080
end type
type st_4 from statictext within w_sal_05080
end type
type st_3 from statictext within w_sal_05080
end type
type st_2 from statictext within w_sal_05080
end type
type st_1 from statictext within w_sal_05080
end type
type cb_2 from commandbutton within w_sal_05080
end type
type cb_1 from commandbutton within w_sal_05080
end type
end forward

global type w_sal_05080 from window
integer x = 206
integer y = 512
integer width = 3246
integer height = 1216
boolean titlebar = true
string title = "자동실행"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
st_mes st_mes
st_nexttime st_nexttime
st_nextdate st_nextdate
st_broken st_broken
st_failures st_failures
st_lasttime st_lasttime
st_lastdate st_lastdate
st_what st_what
st_jobno st_jobno
st_13 st_13
st_12 st_12
st_11 st_11
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_2 cb_2
cb_1 cb_1
end type
global w_sal_05080 w_sal_05080

event open;//variable jobno number;
//EXECUTE dbms_job.submit(:jobno,'erp000000065;',trunc(sysdate) +3/24,'trunc(sysdate + 1) + 3/24',false);

//EXECUTE dbms_job.submit(:jobno,'ERP000000310;',trunc(sysdate+1) +4/24,'trunc(sysdate + 1) + 4/24',false);

//EXECUTE dbms_job.submit(:jobno,'ERP000000310_WORK;',trunc(sysdate+1) +4/24,'trunc(sysdate + 1) + 4/24',false);

//EXECUTE dbms_job.submit(:jobno,'acsp050;', trunc(sysdate + 1) + 01/24, 'trunc(sysdate + 1) + 01/24', false); 

/* Job의 실행여부 */
//SELECT sid, r.job, log_user, r.this_date, r.this_sec
// FROM dba_jobs_running r, dba_jobs j   
// WHERE r.job = j.job;

/* 다음수행일자 변경 */
//DBMS_JOB.CHANGE( job                     IN  BINARY_INTEGER,
//          what                          IN  VARCHAR2,
//          next_date                      IN  DATE,
//          interval                       IN  VARCHAR2)
//execute dbms_job.change(5,null,trunc(sysdate ) + 3/24,null)
			 
st_3.text = " " + '~n' + &
"variable jobno number;" + '~n' + &
"Begin" + '~n' + &
" dbms_job.submit(:jobno," + '~n' + &
"          'erp000000065;'," + '~n' + &
"          null," + '~n' + &
"			  trunc(sysdate + 1) + 3/24,"   + '~n' + &
"          false);" + '~n' + &
"End;" + '~n' + &
"/" + '~n' + &
"print jobno "  + '~n' + &
"(신규로 실행할 경우 필히 jobno를" + '~n' + &
"기억하십시요"


st_4.text = " " + '~n' + &
"Job의 실행여부" + '~n' + &
"    select job, what, next_date," + '~n' + &
"    next_sec, failures, broken" + '~n' + &
"    from user_jobs" + '~n' + &
"Job의 강제실행" + '~n' + &
"    execute dbms_job.run(21);" + '~n' + &
"Job을 Disable시킴" + '~n' + &
"    execute dbms_job.broken(21);" + '~n' + &
"Job의 삭제" + '~n' + &
"    execute dbms_job.remove(21);"


// 현재 Job의 상태
string swhat, slastdate, slastsec, snextdate, snextsec, sfailures, sbroken, sjob

select job, 
       what,
		 to_char(last_date, 'yyyy/mm/dd'), 
		 last_sec,
		 to_char(next_date, 'yyyy/mm/dd'), 
		 next_sec,
		 failures, broken
  into :sjob, :swhat,
  		 :slastdate, :slastsec, :snextdate, :snextsec,
       :sfailures, :sbroken
  from user_jobs
 where job = 1;

st_jobno.text = sjob
st_what.text = swhat
st_lastdate.text = slastdate
st_lasttime.text = slastsec
st_nextdate.text = snextdate
st_nexttime.text = snextsec
st_failures.text = sfailures
st_broken.text = sbroken
st_jobno.text = sjob

end event

on w_sal_05080.create
this.st_mes=create st_mes
this.st_nexttime=create st_nexttime
this.st_nextdate=create st_nextdate
this.st_broken=create st_broken
this.st_failures=create st_failures
this.st_lasttime=create st_lasttime
this.st_lastdate=create st_lastdate
this.st_what=create st_what
this.st_jobno=create st_jobno
this.st_13=create st_13
this.st_12=create st_12
this.st_11=create st_11
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_mes,&
this.st_nexttime,&
this.st_nextdate,&
this.st_broken,&
this.st_failures,&
this.st_lasttime,&
this.st_lastdate,&
this.st_what,&
this.st_jobno,&
this.st_13,&
this.st_12,&
this.st_11,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_2,&
this.cb_1}
end on

on w_sal_05080.destroy
destroy(this.st_mes)
destroy(this.st_nexttime)
destroy(this.st_nextdate)
destroy(this.st_broken)
destroy(this.st_failures)
destroy(this.st_lasttime)
destroy(this.st_lastdate)
destroy(this.st_what)
destroy(this.st_jobno)
destroy(this.st_13)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

type st_mes from statictext within w_sal_05080
boolean visible = false
integer x = 2062
integer y = 1004
integer width = 1051
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "작업을 실행중입니다....!!"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_nexttime from statictext within w_sal_05080
integer x = 2510
integer y = 892
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_nextdate from statictext within w_sal_05080
integer x = 2510
integer y = 800
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_broken from statictext within w_sal_05080
integer x = 2510
integer y = 708
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_failures from statictext within w_sal_05080
integer x = 2510
integer y = 616
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_lasttime from statictext within w_sal_05080
integer x = 2510
integer y = 524
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_lastdate from statictext within w_sal_05080
integer x = 2510
integer y = 432
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_what from statictext within w_sal_05080
integer x = 2510
integer y = 340
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_jobno from statictext within w_sal_05080
integer x = 2510
integer y = 248
integer width = 617
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_13 from statictext within w_sal_05080
integer x = 2057
integer y = 708
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Broken"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_12 from statictext within w_sal_05080
integer x = 2057
integer y = 616
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Failures"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_11 from statictext within w_sal_05080
integer x = 2057
integer y = 892
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Next-Time"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_10 from statictext within w_sal_05080
integer x = 2057
integer y = 800
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Next-Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_9 from statictext within w_sal_05080
integer x = 2057
integer y = 524
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Last-Time"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_8 from statictext within w_sal_05080
integer x = 2057
integer y = 432
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Last-Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_7 from statictext within w_sal_05080
integer x = 2057
integer y = 340
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "What"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_6 from statictext within w_sal_05080
integer x = 2057
integer y = 248
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Job No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_sal_05080
integer x = 1038
integer y = 164
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Job 관리 방법"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sal_05080
integer x = 1029
integer y = 248
integer width = 1015
integer height = 720
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sal_05080
integer x = 5
integer y = 248
integer width = 1015
integer height = 720
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_sal_05080
integer y = 164
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Job 정의 방법"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sal_05080
integer x = 27
integer y = 16
integer width = 3145
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8421376
long backcolor = 67108864
boolean enabled = false
string text = "실행일자, 실행시간등을 변경하고자 하는경우에는 아래의 내용을 이용하여 전산관리자가 수정한다."
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sal_05080
integer x = 1029
integer y = 976
integer width = 1015
integer height = 108
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_sal_05080
integer x = 5
integer y = 976
integer width = 1015
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "지금실행"
end type

event clicked;st_mes.visible = true

sqlca.erp000000065();

// 현재 Job의 상태
string swhat, slastdate, slastsec, snextdate, snextsec, sfailures, sbroken, sjob

select job, 
       what,
		 to_char(last_date, 'yyyy/mm/dd'), 
		 last_sec,
		 to_char(next_date, 'yyyy/mm/dd'), 
		 next_sec,
		 failures, broken
  into :sjob, :swhat,
  		 :slastdate, :slastsec, :snextdate, :snextsec,
       :sfailures, :sbroken
  from user_jobs
 where job = 1;

st_jobno.text = sjob
st_what.text = swhat
st_lastdate.text = slastdate
st_lasttime.text = slastsec
st_nextdate.text = snextdate
st_nexttime.text = snextsec
st_failures.text = sfailures
st_broken.text = sbroken
st_jobno.text = sjob

st_mes.visible = false

Messagebox("자동실행", "실행이 완료되었읍니다")

end event

