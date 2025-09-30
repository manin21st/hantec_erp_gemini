$PBExportHeader$w_sal_05680.srw
$PBExportComments$월별 생산금액 대 판매금액 현황
forward
global type w_sal_05680 from w_standard_dw_graph
end type
end forward

global type w_sal_05680 from w_standard_dw_graph
string title = "월별 생산금액 대 판매금액 현황"
end type
global w_sal_05680 w_sal_05680

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syymm,pdtgu,itcls,itclsnm
string   tx_pdtgu,tx_intbrnm
int      rtn

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm  = trim(dw_ip.getitemstring(1, 'syymm'))
pdtgu  = trim(dw_ip.getitemstring(1, 'pdtgu'))
itcls  = trim(dw_ip.getitemstring(1, 'itcls'))
itclsnm= trim(dw_ip.getitemstring(1, 'itclsnm'))

If IsNull(pdtgu)  Then pdtgu = ''
If IsNull(itcls)  Then itcls = ''
If IsNull(itclsnm)  Then itclsnm = '전체'

IF	f_datechk(syymm+'01') = -1 then
	MessageBox("확인","기준년월을 확인하세요!")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	Return -1
END IF

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

rtn = dw_list.retrieve(gs_sabu, syymm, pdtgu+'%', itcls+'%',ls_silgu)

If rtn < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	dw_list.SetRedraw(True)
	return -1
End if

  
// title 년월 설정

tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If tx_pdtgu = '' Then tx_pdtgu = '전체'

dw_list.Object.tx_pdtgu.text = tx_pdtgu
dw_list.Object.tx_itcls.text = itclsnm

dw_list.SetRedraw(True)


Return 1


end function

on w_sal_05680.create
call super::create
end on

on w_sal_05680.destroy
call super::destroy
end on

event open;call super::open;dw_ip.SetItem(1,'syymm',Left(f_today(),6))


end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05680
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05680
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05680
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05680
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05680
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05680
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05680
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05680
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05680
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05680
integer x = 5
integer y = 28
integer width = 4009
integer height = 160
string dataobject = "d_sal_05680_01"
end type

event dw_ip::itemchanged;string cvcodnm
string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec
string s_name,s_itt,snull,get_nm

Choose Case  GetColumnName() 
	Case 'itcls'
		s_name = Trim(this.gettext())
      s_itt  = '1'
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
End Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

this.accepttext()
nRow = GetRow()

if this.GetColumnName() = 'itcls' then
	sIttyp = '1' // 완제품
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if


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
//		    this.SetItem(1, "ittyp", str_sitnct.s_ittyp)
		    this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		    this.SetItem(1, "itclsnm", str_sitnct.s_titnm)
	END Choose
End if	

end event

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05680
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05680
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05680
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05680
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05680
string dataobject = "d_sal_05680"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05680
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05680
end type

