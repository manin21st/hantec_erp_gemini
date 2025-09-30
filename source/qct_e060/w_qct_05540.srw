$PBExportHeader$w_qct_05540.srw
$PBExportComments$월 교정 계획서
forward
global type w_qct_05540 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_05540
end type
end forward

global type w_qct_05540 from w_standard_print
string title = "월 교정 계획서 "
rr_1 rr_1
end type
global w_qct_05540 w_qct_05540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string frdate, todate, mchno1, mchno2, gubun, buncd, buncd1

if dw_ip.accepttext() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

frdate  = Trim(dw_ip.GetItemString(1,'syymm'))
todate  = Trim(dw_ip.GetItemString(1,'eyymm'))
//mchno1  = Trim(dw_ip.GetItemString(1,'smchno'))
//mchno2  = Trim(dw_ip.GetItemString(1,'emchno'))
gubun   = dw_ip.object.gubun[1]
buncd  = trim(dw_ip.object.buncd[1])
buncd1 = trim(dw_ip.object.buncd1[1])

IF	IsNull(frdate) or frdate = '' then frdate = "100001" 
IF	IsNull(todate) or todate = '' then todate = "999912"
//IF	IsNull(mchno1) or mchno1 = '' then mchno1 = "."
//IF	IsNull(mchno2) or mchno2 = '' then mchno2 = "ZZZZZZ"
if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz'

//dw_list.object.txt_ym.Text = String(frdate, "@@@@년@@월")
//dw_list.object.txt_ym1.Text = String(todate, "@@@@년@@월")

//if dw_list.retrieve(gs_sabu, frdate, todate, gubun, buncd, buncd1) <= 0	then
//	f_message_chk(50,"[월 교정 계획서]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.retrieve(gs_sabu, frdate, todate, gubun, buncd, buncd1) <= 0	then
	f_message_chk(50,"[월 교정 계획서]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1

end function

on w_qct_05540.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_05540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'syymm', left(is_today, 6))
dw_ip.SetItem(1,'eyymm', left(is_today, 6))


end event

type p_preview from w_standard_print`p_preview within w_qct_05540
end type

type p_exit from w_standard_print`p_exit within w_qct_05540
end type

type p_print from w_standard_print`p_print within w_qct_05540
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05540
end type







type st_10 from w_standard_print`st_10 within w_qct_05540
end type



type dw_print from w_standard_print`dw_print within w_qct_05540
string dataobject = "d_qct_05540_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05540
integer x = 64
integer y = 48
integer width = 2848
integer height = 204
string dataobject = "d_qct_05540_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

gs_code = '계측기'
Choose Case GetColumnName()
	Case "buncd" 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd[1] = gs_code
	
   Case "buncd1" 
		gs_gubun = 'ALL'
		gs_code = '계측기'
		gs_codename = '계측기관리번호'
		open(w_mchno_popup)
		if isnull(gs_code) or gs_code = '' then return
		this.object.buncd1[1] = gs_code
end choose


end event

event dw_ip::itemchanged;String s_cod, s_nam, ls_buncd

s_cod = Trim(this.getText())

if this.GetColumnName() = "syymm" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod+'01') = -1 then
		f_message_chk(35, "[시작년월]")
		this.object.syymm[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "eyymm" then 	
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod+'01') = -1 then
		f_message_chk(35, "[끝년월]")
		this.object.eyymm[1] = ""
		return 1
	end if
end if
//elseif this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//        FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//                setitem(1 , "buncd", '')
//		return 2 
//	end if
//
//elseif this.GetColumnName() = "buncd1" then    // 계측기 관리번호
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//	FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      		setitem(1 , "buncd1", '')
//		return 2 
//	end if
//	
//elseif this.GetColumnName() = "smchno" then 	
//   if IsNull(s_cod) or s_cod = "" then 
//	   this.object.smchnm[1] = ""
//		Return 
//   end if
//	
//   select mchnam into :s_nam
//     from mchmst
//    where sabu = :gs_saupj and mchno = :s_cod;
// 
//   if sqlca.sqlcode <> 0 then //설비마스터에 존재하지 않을 때
//	   this.object.smchnm[1] = ""
//   else
//	   this.object.smchnm[1] = s_nam
//	end if
//	
//elseif this.GetColumnName() = "emchno" then 	
//   if IsNull(s_cod) or s_cod = "" then 
//	   this.object.emchnm[1] = ""
//		Return 
//   end if
//	
//   select mchnam into :s_nam
//     from mchmst
//    where sabu = :gs_saupj and mchno = :s_cod;
// 
//   if sqlca.sqlcode <> 0 then //설비마스터에 존재하지 않을 때
//	   this.object.emchnm[1] = ""
//   else
//	   this.object.emchnm[1] = s_nam
//	end if

	


end event

type dw_list from w_standard_print`dw_list within w_qct_05540
integer x = 82
integer y = 264
integer width = 4498
integer height = 2056
string dataobject = "d_qct_05540_02"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_qct_05540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 256
integer width = 4526
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

