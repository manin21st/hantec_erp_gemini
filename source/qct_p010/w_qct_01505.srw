$PBExportHeader$w_qct_01505.srw
$PBExportComments$** 재검사 대기현황
forward
global type w_qct_01505 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_01505
end type
end forward

global type w_qct_01505 from w_standard_print
integer height = 2596
string title = "재검사 대기현황"
rr_1 rr_1
end type
global w_qct_01505 w_qct_01505

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_insemp, s_empnam ,ls_gubun1

IF dw_ip.AcceptText() = -1 THEN RETURN -1

s_insemp = TRIM(dw_ip.GetItemString(1,"s_insemp"))
ls_gubun1= trim(dw_ip.getitemstring(1,'gubun1'))

SELECT "REFFPF"."RFNA1"
  INTO :s_empnam  
  FROM "REFFPF"
  WHERE "REFFPF"."RFCOD" = '45' and
		  "REFFPF"."RFGUB" = :s_insemp;
		  
dw_list.setredraw(false)
IF IsNull(s_insemp) OR s_insemp = ''	THEN
	if ls_gubun1 = '1' then  //사내용전체
	   dw_list.DataObject = 'd_qct_01505_1_list'
	   dw_print.DataObject = 'd_qct_01505_1'
	else                    //사외용전체 
		dw_list.DataObject = 'd_qct_01505_4_list' 
		dw_print.DataObject = 'd_qct_01505_4' 
	end if
ELSE
	if ls_gubun1 ='1' then //사내용, 사원
		dw_list.DataObject = 'd_qct_01505_2_list'
		dw_print.DataObject = 'd_qct_01505_2'
		dw_print.Object.t_insemp.Text = s_empnam
	else                   //사외용, 사원
		dw_list.DataObject = 'd_qct_01505_3_list'
		dw_print.DataObject = 'd_qct_01505_3'
		dw_print.Object.t_insemp.Text = s_empnam
	end if
END IF
dw_list.setredraw(true)

dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//IF IsNull(s_insemp) OR s_insemp = ''	THEN
//	IF dw_list.Retrieve(gs_sabu) < 1 THEN
//		f_message_chk(50,"[재검사 대기 현황]")
//		dw_ip.SetColumn('s_insemp')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//ELSE
//	IF dw_list.Retrieve(gs_sabu, s_insemp) < 1 THEN
//		f_message_chk(50,"[재검사 대기 현황]")
//		dw_ip.SetColumn('s_insemp')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//END IF

IF IsNull(s_insemp) OR s_insemp = ''	THEN
	IF dw_print.Retrieve(gs_sabu) < 1 THEN
		f_message_chk(50,"[재검사 대기 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
	//	Return -1
	END IF
ELSE
	IF dw_print.Retrieve(gs_sabu, s_insemp) < 1 THEN
		f_message_chk(50,"[재검사 대기 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
	//	Return -1
	END IF
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_qct_01505.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_01505.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;/* 생산팀 & 영업팀 & 관할구역 Filtering */

DataWindowChild state_child
integer rtncode

//담당자
rtncode 	= dw_ip.GetChild('s_insemp', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('45',gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_qct_01505
end type

type p_exit from w_standard_print`p_exit within w_qct_01505
end type

type p_print from w_standard_print`p_print within w_qct_01505
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01505
end type







type st_10 from w_standard_print`st_10 within w_qct_01505
end type



type dw_print from w_standard_print`dw_print within w_qct_01505
string dataobject = "d_qct_01505_2"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01505
integer x = 32
integer y = 8
integer width = 2144
integer height = 160
string dataobject = "d_qct_01505"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_01505
integer x = 64
integer y = 216
integer width = 4530
integer height = 2084
string dataobject = "d_qct_01505_1_list"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_01505
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 208
integer width = 4567
integer height = 2112
integer cornerheight = 40
integer cornerwidth = 55
end type

