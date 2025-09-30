$PBExportHeader$w_qct_01500.srw
$PBExportComments$**수입/특채 검사대기현황(출력)
forward
global type w_qct_01500 from w_standard_print
end type
type rr_2 from roundrectangle within w_qct_01500
end type
end forward

global type w_qct_01500 from w_standard_print
string title = "수입/특채 검사 대기현황"
boolean maxbox = true
rr_2 rr_2
end type
global w_qct_01500 w_qct_01500

type variables
datawindowchild idws

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string   s_insemp, s_empnam, sGubun, sGubun2

if Dw_ip.AcceptText() = -1 then return -1

s_insemp 	= trim(dw_ip.GetItemString(1, "s_insemp"))
sGubun	 	= dw_ip.GetItemString(1, "gubun")
sGubun2	 	= dw_ip.GetItemString(1, "gubun2")

if not (isnull(s_insemp) or s_insemp = '') then 
	SELECT "REFFPF"."RFNA1"
	  INTO :s_empnam  
	  FROM "REFFPF"
	  WHERE "REFFPF"."RFCOD" = '45' and
			  "REFFPF"."RFGUB" = :s_insemp;
end if			  

if sGubun2 = '2' then 
	sGubun2 = '007'
else
	sGubun2 = '025'
end if

Choose Case sGubun
	 Case '1'          //입고의뢰별 
			if isnull(s_insemp) or Trim(s_insemp) = '' then
				dw_list.dataobject  = 'd_qct_01501'
				dw_print.DataObject = 'd_qct_01501_p'
			else
				dw_list.DataObject = 'd_qct_01502'
//				dw_list.Object.t_insemp.Text = s_empnam 	
				dw_print.DataObject = 'd_qct_01502_p'
			end if
	 Case '2'
			if isnull(s_insemp) or Trim(s_insemp) = '' then
				dw_list.dataobject = 'd_qct_01501_1'
				dw_print.DataObject = 'd_qct_01501_1_p'
			else
				dw_list.DataObject = 'd_qct_01502_1'
//				dw_list.Object.t_insemp.Text = s_empnam 	
				
				dw_print.DataObject = 'd_qct_01502_1_p'
			end if
	 Case '3'
			if isnull(s_insemp) or Trim(s_insemp) = '' then
				dw_list.dataobject = 'd_qct_01501_2'
				dw_print.DataObject = 'd_qct_01501_2_p'
			else
				dw_list.DataObject = 'd_qct_01502_2'
//				dw_list.Object.t_insemp.Text = s_empnam
				
				dw_print.DataObject = 'd_qct_01502_2_p'
			end if
End choose

dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

//if isnull(s_insemp) or s_insemp = '' then
//	IF dw_list.Retrieve(gs_sabu, sGubun2) < 1 THEN
//		f_message_chk(50,"[검사 대기 현황]")
//		dw_ip.SetColumn('s_insemp')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//ELSE
//	IF dw_list.Retrieve(gs_sabu, s_insemp, sGubun2) < 1 THEN
//		f_message_chk(50,"[검사 대기 현황]")
//		dw_ip.SetColumn('s_insemp')
//		dw_ip.SetFocus()
//		return -1
//	END IF
//END IF

if isnull(s_insemp) or s_insemp = '' then
	IF dw_print.Retrieve(gs_sabu, sGubun2) < 1 THEN
		f_message_chk(50,"[검사 대기 현황]")
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
	//	Return -1
	END IF
ELSE
	IF dw_print.Retrieve(gs_sabu, s_insemp, sGubun2) < 1 THEN
		f_message_chk(50,"[검사 대기 현황]")
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

on w_qct_01500.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_qct_01500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;dw_ip.getchild("s_insemp", idws)

idws.settransobject(sqlca)

if idws.retrieve('2') < 1 then 
	idws.reset()
	idws.insertrow(0)
end if	

CALL SUPER ::OPEN

end event

type p_preview from w_standard_print`p_preview within w_qct_01500
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_qct_01500
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_qct_01500
integer x = 4247
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01500
integer x = 3899
end type







type st_10 from w_standard_print`st_10 within w_qct_01500
end type



type dw_print from w_standard_print`dw_print within w_qct_01500
string dataobject = "d_qct_01501_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01500
integer x = 64
integer y = 32
integer width = 3278
integer height = 140
string dataobject = "d_qct_01500"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string	sCode

// 검사담당자
IF this.GetColumnName() = 'gubun2' THEN

	sCode = this.gettext()
	
	if idws.retrieve(sCode) < 1 then 
		idws.reset()
		idws.insertrow(0)
	end if	
	 
   this.setitem(1, 's_insemp', '')	 
END IF


end event

type dw_list from w_standard_print`dw_list within w_qct_01500
integer x = 82
integer y = 184
integer width = 4494
integer height = 2116
string dataobject = "d_qct_01502"
boolean border = false
end type

type rr_2 from roundrectangle within w_qct_01500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 176
integer width = 4521
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

