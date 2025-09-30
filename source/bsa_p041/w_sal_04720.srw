$PBExportHeader$w_sal_04720.srw
$PBExportComments$입금표 배포 및 소손현황
forward
global type w_sal_04720 from w_standard_print
end type
end forward

global type w_sal_04720 from w_standard_print
string title = "입금표 배포 및 소손현황"
long backcolor = 80859087
end type
global w_sal_04720 w_sal_04720

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sGubun, sYM, sFrom, sTo, sS, sS_Name, sNull

SetNull(sNull)

If dw_ip.AcceptText() <> 1 Then Return -1

sGubun = dw_ip.GetItemString(1, 'gubun')
if sGubun = '1' then
   sYM = Trim(dw_ip.GetItemString(1,'sym'))
   if	(sYM='') or isNull(sYM) then
	   f_Message_Chk(30, '[기준년월]')
   	dw_ip.setcolumn('sym')
	   dw_ip.setfocus()
   	Return -1
   END IF
	
	dw_print.object.r_ym.Text = Left(sYM,4) + '년 ' + Right(sYM,2) + '월'
   if dw_print.Retrieve(sYM) < 1 then
	   f_message_Chk(300, '[출력조건 CHECK]')
	   dw_ip.setcolumn('sym')
	   dw_ip.setfocus()
	   return -1
	end if	
else
   sFrom = Trim(dw_ip.GetItemString(1,'g_from'))
   if f_DateChk(sFrom) = -1 then
	   f_Message_Chk(30, '[시작일자]')
   	dw_ip.SetItem(1, "g_from", sNull)
	   dw_ip.setcolumn("g_from")
   	dw_ip.SetFocus()
	   return -1
   end if

   sTo = Trim(dw_ip.GetItemString(1,'g_to'))
   if f_DateChk(sTo) = -1 then
	   f_Message_Chk(30, '[종료일자]')
   	dw_ip.SetItem(1, "g_to", sNull)
	   dw_ip.setcolumn("g_to")
   	dw_ip.SetFocus()
	   return -1
   end if

   // 관할구역 선택
   sS = Trim(dw_ip.GetItemString(1,'sarea'))
   if sS= '' or isNull(sS) then
	   sS = '%'
   	sS_Name = '전  체'
   else
	   Select sareanm Into :sS_Name 
   	From sarea
	   Where sarea = :sS;
   	if isNull(sS_Name) then
	   	sS_Name = ''
   	end if
   end if

	dw_print.object.r_sarea.Text = sS_Name

   if dw_print.Retrieve(sFrom, sTo, sS) < 1 then
	   f_message_Chk(300, '[출력조건 CHECK]')
	   dw_ip.setcolumn('sym')
	   dw_ip.setfocus()
	   return -1
	end if		
end if

dw_print.ShareData(dw_list)

return 1



//String  sGubun, sYM, sFrom, sTo, sS, sS_Name, sNull
//
//SetNull(sNull)
//
//If dw_ip.AcceptText() <> 1 Then Return -1
//
//sGubun = dw_ip.GetItemString(1, 'gubun')
//if sGubun = '1' then
//   sYM = Trim(dw_ip.GetItemString(1,'sym'))
//   if	(sYM='') or isNull(sYM) then
//	   f_Message_Chk(30, '[기준년월]')
//   	dw_ip.setcolumn('sym')
//	   dw_ip.setfocus()
//   	Return -1
//   END IF
//	
//	dw_print.object.r_ym.Text = Left(sYM,4) + '년 ' + Right(sYM,2) + '월'
//   if dw_list.Retrieve(sYM) < 1 then
//	   f_message_Chk(300, '[출력조건 CHECK]')
//	   dw_ip.setcolumn('sym')
//	   dw_ip.setfocus()
//	   return -1
//	end if	
//else
//   sFrom = Trim(dw_ip.GetItemString(1,'g_from'))
//   if f_DateChk(sFrom) = -1 then
//	   f_Message_Chk(30, '[시작일자]')
//   	dw_ip.SetItem(1, "g_from", sNull)
//	   dw_ip.setcolumn("g_from")
//   	dw_ip.SetFocus()
//	   return -1
//   end if
//
//   sTo = Trim(dw_ip.GetItemString(1,'g_to'))
//   if f_DateChk(sTo) = -1 then
//	   f_Message_Chk(30, '[종료일자]')
//   	dw_ip.SetItem(1, "g_to", sNull)
//	   dw_ip.setcolumn("g_to")
//   	dw_ip.SetFocus()
//	   return -1
//   end if
//
//   // 관할구역 선택
//   sS = Trim(dw_ip.GetItemString(1,'sarea'))
//   if sS= '' or isNull(sS) then
//	   sS = '%'
//   	sS_Name = '전  체'
//   else
//	   Select sareanm Into :sS_Name 
//   	From sarea
//	   Where sarea = :sS;
//   	if isNull(sS_Name) then
//	   	sS_Name = ''
//   	end if
//   end if
//
//	dw_list.object.r_sarea.Text = sS_Name
//
//   if dw_list.Retrieve(sFrom, sTo, sS) < 1 then
//	   f_message_Chk(300, '[출력조건 CHECK]')
//	   dw_ip.setcolumn('sym')
//	   dw_ip.setfocus()
//	   return -1
//	end if		
//end if
//
//
//return 1
end function

on w_sal_04720.create
call super::create
end on

on w_sal_04720.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.setitem(1,'sym',left(f_today(),6))
dw_ip.setitem(1,'g_from',left(f_today(),6) + '01')
dw_ip.setitem(1,'g_to',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_sal_04720
end type

type p_exit from w_standard_print`p_exit within w_sal_04720
end type

type p_print from w_standard_print`p_print within w_sal_04720
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04720
end type







type st_10 from w_standard_print`st_10 within w_sal_04720
end type



type dw_print from w_standard_print`dw_print within w_sal_04720
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04720
integer y = 96
integer height = 636
string dataobject = "d_sal_04720"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, sSdate, sEdate

sCol_Name = GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
	Case "gubun"
		SetItem(1, 'sym', sNull)
		SetItem(1, 'g_from', sNull)
		SetItem(1, 'g_to', sNull)
		SetItem(1, 'sarea', sNull)
		
		dw_list.SetRedraw(False)
		if GetText() = '1' then
			dw_list.DataObject = "d_sal_04720_01"
			dw_list.Settransobject(sqlca)
			dw_ip.setitem(1,'sym',left(f_today(),6))
			
		elseif GetText() = '2' Then
			dw_list.DataObject = "d_sal_04720_02"
			dw_list.Settransobject(sqlca)		
			dw_ip.setitem(1,'g_from',left(f_today(),6) + '01')
			dw_ip.setitem(1,'g_to',left(f_today(),8))
		Else
			dw_list.DataObject = "d_sal_04720_03"
			dw_list.Settransobject(sqlca)
			dw_ip.setitem(1,'g_from',left(f_today(),6) + '01')
			dw_ip.setitem(1,'g_to',left(f_today(),8))
		End If		
		dw_list.SetRedraw(True)

   // 기준년월 유효성 Check
	Case "sym"  
		if f_DateChk(Trim(getText()+'01')) = -1 then
			f_Message_Chk(30, '[기준년월]')
			SetItem(1, "sym", sNull)
			return 1
		end if		
		
   // 기간시작일자 유효성 Check
	Case "g_from"  
		if f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(30, '[기간시작일자]')
			SetItem(1, "g_from", sNull)
			return 1
		end if
		
	// 기간끝일자 유효성 Check
   Case "g_to"
		if f_DateChk(Trim(getText())) = -1 then
			f_Message_Chk(30, '[기간종료일자]')
			SetItem(1, "g_to", sNull)
			return 1
		end if	
		sSdate = GetItemString(1, 'g_from')
		sEdate = GetText()
      if	( sSDate > sEDate ) then
      	f_message_Chk(200, '[시작 및 종료일 CHECK]')
      	dw_ip.setcolumn("g_from")
       	dw_ip.setfocus()
      	Return 1
      end if	
		
	Case "sarea"
//		cb_update.SetFocus()
end Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_04720
string dataobject = "d_sal_04720_01"
end type

