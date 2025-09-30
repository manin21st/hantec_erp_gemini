$PBExportHeader$w_sal_05690.srw
$PBExportComments$년간 판매목표 대 실적현황
forward
global type w_sal_05690 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05690
end type
end forward

global type w_sal_05690 from w_standard_print
string title = "년간 판매목표 대 실적현황"
rr_1 rr_1
end type
global w_sal_05690 w_sal_05690

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String	syymm,pdtgu,ittyp,itcls,ls_gubun , ls_pgubun
Integer  nChasu

////////////////////////////////////////////////////// 조건절값
If dw_ip.accepttext() <> 1 Then Return -1

ls_pgubun = trim(dw_ip.getitemstring(1,'pgubun'))

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

if ls_pgubun = '1' then
		syymm = trim(dw_ip.getitemstring(1, 'syymm'))
		pdtgu = trim(dw_ip.getitemstring(1, 'pdtgu'))
		ittyp = trim(dw_ip.getitemstring(1, 'ittyp'))
		itcls = trim(dw_ip.getitemstring(1, 'itcls'))
		ls_gubun = trim(dw_ip.getitemstring(1, 'gubun'))
		
		If IsNull(pdtgu)  Then pdtgu = ''
		If IsNull(ittyp)  Then ittyp = ''
		If IsNull(itcls)  Then itcls = ''
		////////////////////////////////////////////////////// 기간 유효성 check
		IF	f_datechk(syymm+'0101') = -1 then
			MessageBox("확인","기준년도를 확인하세요!")
			dw_ip.setcolumn('syymm')
			dw_ip.setfocus()
			Return -1
		END IF
		
		////////////////////////////////////////////////////// 검색
		SetPointer(HourGlass!)
		dw_print.SetRedraw(False)
		
		Select nvl(max(plan_chasu),1) into :nChasu
		  from yearsaplan
		 where sabu = :gs_sabu and
				 plan_yymm like :syymm||'%'; 
		
		If IsNull(nChasu) or nChasu = 0 then nChasu = 1
		
		if dw_print.retrieve(gs_sabu, syymm, nchasu,ls_gubun,ls_silgu) < 1	then
			f_message_chk(50,"")
			dw_ip.setcolumn('pdtgu')
			dw_ip.setfocus()
			return -1
		end if
		
		////////////////////////////////////////////////////// 타이틀 설정
		string tx_pdtgu,tx_ittyp,tx_itcls
		
		tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
		tx_ittyp = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
		tx_itcls = trim(dw_ip.getitemstring(1, 'itclsnm'))
		
		If tx_pdtgu = '' Then tx_pdtgu = '전체'
		If tx_ittyp = '' Then tx_ittyp = '전체'
		If IsNull(tx_itcls)  Then tx_itcls = '전체'
		
		dw_print.Object.tx_pdtgu.text = tx_pdtgu
		dw_print.Object.tx_ittyp.text = tx_ittyp
		dw_print.Object.tx_itcls.text = tx_itcls
		
		IF ls_gubun='1' then
			dw_print.Object.tx_1.text = '금액단위 : 천원 ,수량단위 :개 '
			dw_print.Object.tx_2.text = '목표누계수량'
			dw_print.Object.tx_3.text = '실적누계수량'
			dw_print.Object.tx_4.text = '누계달성수량'
		else
			dw_print.Object.tx_1.text = '금액단위 : 천원 '
			dw_print.Object.tx_2.text = '목표누계금액'
			dw_print.Object.tx_3.text = '실적누계금액'
			dw_print.Object.tx_4.text = '누계달성액'
		end if

		Return 1
	else
		//////////////////////////////////////////////////////////////////
		If dw_ip.accepttext() <> 1 Then Return -1
		
		syymm  = trim(dw_ip.GetItemString(1,'syymm'))
		ls_gubun = trim(dw_ip.getitemstring(1,'gubun'))
		
		IF	IsNull(syymm) or syymm = '' then
			f_message_chk(1400,'[기준년도]')
			dw_ip.setcolumn('syymm')
			dw_ip.setfocus()
			Return -1
		END IF
		
		If dw_print.retrieve(gs_sabu, syymm,ls_gubun,ls_silgu) <= 0	then
			f_message_chk(50,"")
			dw_ip.setcolumn('syymm')
			dw_ip.setfocus()
			dw_print.InsertRow(0)
//			Return -1
		else
			dw_print.sharedata(dw_list)
		End if
		
		if ls_gubun='1' then
			dw_print.object.tx_1.text = '금액단위 : 천원    수량단위 : 개 '
			dw_print.object.tx_2.text = '판매목표수량'
			dw_print.object.tx_3.text = '매출목표수량'
		else
			dw_print.object.tx_1.text = '금액단위 : 천원'
			dw_print.object.tx_2.text = '판매목표금액'
			dw_print.object.tx_3.text = '매출목표금액'
		end if
		
		Return 0
	end if

end function

on w_sal_05690.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05690.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string syymm

syymm = Left(f_today(),4)
dw_ip.SetItem(1,'syymm',syymm)


end event

type p_preview from w_standard_print`p_preview within w_sal_05690
end type

type p_exit from w_standard_print`p_exit within w_sal_05690
end type

type p_print from w_standard_print`p_print within w_sal_05690
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05690
end type







type st_10 from w_standard_print`st_10 within w_sal_05690
end type



type dw_print from w_standard_print`dw_print within w_sal_05690
string dataobject = "d_sal_05690_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05690
integer x = 73
integer y = 28
integer width = 1504
integer height = 360
string dataobject = "d_sal_05690_01"
end type

event dw_ip::rbuttondown;String s_colname,	sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

If this.accepttext() <> 1 Then Return

s_colname = GetColumnName()
nRow = GetRow()

if this.GetColumnName() = 'itcls' then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec
string s_name,s_itt,snull,get_nm,ls_pgubun

Choose Case  GetColumnName() 
	Case 'itcls'
		s_name = Trim(this.gettext())
	   s_itt = Trim(GetItemString(GetRow(),'ittyp'))
  	   If s_itt = '' Or IsNull(s_itt) Then s_itt = '1'
		  
      IF s_name = "" OR IsNull(s_name) THEN 	
		   This.setitem(1, 'itclsnm', snull)
		   RETURN 
	   END IF
	
      SELECT "ITNCT"."TITNM"  
        INTO :get_nm  
        FROM "ITNCT"  
       WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
             ( "ITNCT"."ITCLS" = :s_name ) ;

   	IF SQLCA.SQLCODE <> 0 THEN
		   this.TriggerEvent(rbuttondown!)
		   if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
			   This.setitem(1, 'itcls', snull)
			   This.setitem(1, 'itclsnm', snull)
			   RETURN 1
         else
			   this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
			   this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
			   this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
            Return 1			
         end if
      ELSE
		   This.setitem(1, 'itclsnm', get_nm)
      END IF
	Case 'pgubun'
		ls_pgubun = Trim(GetText())
		
		dw_list.setredraw(false)
		if ls_pgubun = '1' then
			dw_list.dataobject = 'd_sal_05690'
			dw_print.dataobject = 'd_sal_05690_p'
		else
			dw_list.dataobject = 'd_sal_056901'
			dw_print.dataobject = 'd_sal_056901_p'
		end if
		dw_print.settransobject(sqlca)
		dw_list.settransobject(sqlca)
		dw_list.setredraw(true)
End Choose
end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

SetNull(gs_code)
SetNull(gs_codename)

IF KeyDown(KeyF2!) THEN
	Choose Case GetColumnName()
	   Case  'itcls'
		    open(w_ittyp_popup3) 
			 str_sitnct = Message.PowerObjectParm
			 if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	


end event

type dw_list from w_standard_print`dw_list within w_sal_05690
integer x = 91
integer y = 408
integer width = 4503
integer height = 1896
string dataobject = "d_sal_05690"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_05690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 396
integer width = 4539
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

