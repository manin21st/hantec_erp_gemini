$PBExportHeader$w_sal_05700.srw
$PBExportComments$전년대비 판매목표 대 실적현황
forward
global type w_sal_05700 from w_standard_dw_graph
end type
end forward

global type w_sal_05700 from w_standard_dw_graph
string title = "전년실적 및 판매목표 대 실적현황"
end type
global w_sal_05700 w_sal_05700

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syymm1,syymm2,steam,sarea,cvcod,pdtgu,itcls,itclsnm, sIttyp,ls_gubun
string   tx_steam,tx_sarea,tx_cvcod,tx_pdtgu,tx_intbrnm, tx_ittyp
int      chasu,rtn

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syymm2 = trim(dw_ip.getitemstring(1, 'syymm'))
syymm1 = String(Integer(syymm2) - 1,'0000')
syymm2 = syymm2 + '01'            // 기준년월의 1월로 설정
syymm1 = syymm1 + '01'            // 전년도 1월로 설정

chasu  = dw_ip.getitemNumber(1, 'chasu')
steam  = trim(dw_ip.getitemstring(1, 'steam'))
sarea  = trim(dw_ip.getitemstring(1, 'sarea'))
cvcod  = trim(dw_ip.getitemstring(1, 'cvcod'))
pdtgu  = trim(dw_ip.getitemstring(1, 'pdtgu'))
sIttyp = trim(dw_ip.getitemstring(1, 'ittyp'))
itcls  = trim(dw_ip.getitemstring(1, 'itcls'))
ls_gubun  = trim(dw_ip.getitemstring(1, 'gubun'))

If IsNull(steam)  Then steam = ''
If IsNull(sarea)  Then sarea = ''
If IsNull(cvcod)  Then cvcod = ''
If IsNull(pdtgu)  Then pdtgu = ''
If IsNull(sIttyp) Then sIttyp = ''
If IsNull(itcls)  Then itcls = ''

IF	f_datechk(syymm1+'0101') = -1 then
	MessageBox("확인","기준년도을 확인하세요!")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	Return -1
END IF

IF	IsNull(chasu) Or chasu = 0 then
	MessageBox("확인","계획차수를 확인하세요!")
	dw_ip.setcolumn('chasu')
	dw_ip.setfocus()
	Return -1
END IF

dw_list.SetRedraw(False)

string ls_silgu

SELECT DATANAME
INTO  :ls_silgu
FROM  SYSCNFG
WHERE SYSGU = 'S' AND SERIAL = '8' AND LINENO = '40' ;

rtn = dw_list.retrieve(gs_sabu,syymm1,syymm2,chasu,steam+'%',sarea+'%',cvcod+'%',pdtgu+'%', sIttyp+'%', itcls+'%',ls_gubun,ls_silgu)

If rtn < 1	Then
	f_message_chk(50,"")
	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	dw_list.SetRedraw(True)
	return -1
End if

// title 년월 설정
//
tx_steam = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(steam) ', 1)"))
tx_sarea = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sarea) ', 1)"))
tx_cvcod = trim(dw_ip.getitemstring(1, 'cvcodnm'))
tx_pdtgu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
tx_Ittyp = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ittyp) ', 1)"))
itclsnm= trim(dw_ip.getitemstring(1, 'itclsnm'))

If tx_steam = '' Then tx_steam = '전체'
If tx_sarea = '' Then tx_sarea = '전체'
If IsNull(tx_cvcod) Or tx_cvcod = '' Then tx_cvcod = '전체'
If tx_pdtgu = '' Then tx_pdtgu = '전체'
If tx_ittyp = '' Then tx_ittyp = '전체'
If itclsnm  = '' Then itclsnm = '전체'
If IsNull(itclsnm)  Then itclsnm = '전체'

dw_list.Object.tx_chasu.text = string(chasu) + '차'
dw_list.Object.tx_steam.text = tx_steam
dw_list.Object.tx_sarea.text = tx_sarea
dw_list.Object.tx_cvcod.text = tx_cvcod
dw_list.Object.tx_pdtgu.text = tx_pdtgu
dw_list.Object.tx_ittyp.text = tx_ittyp
dw_list.Object.tx_itcls.text = itclsnm

if ls_gubun = '1' then
	dw_list.Object.tx_1.text = '(수량단위 : 개)'
	dw_list.Object.st11.text = '전년도 판매수량'
	dw_list.Object.tx_2.text = '누계수량'
	dw_list.Object.tx_3.text = '당년도 계획수량'
	dw_list.Object.tx_4.text = '누계수량'
	dw_list.Object.tx_5.text = '당년도 판매수량'
	dw_list.Object.tx_6.text = '누계수량'
else
   dw_list.Object.tx_1.text = '(금액단위 : 원)'
	dw_list.Object.st11.text = '전년도 판매금액'
	dw_list.Object.tx_2.text = '누계금액'
	dw_list.Object.tx_3.text = '당년도 계획금액'
	dw_list.Object.tx_4.text = '누계금액'
	dw_list.Object.tx_5.text = '당년도 판매금액'
	dw_list.Object.tx_6.text = '누계금액'
end if

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_05700.create
call super::create
end on

on w_sal_05700.destroy
call super::destroy
end on

event open;call super::open;dw_ip.SetItem(1,'syymm',Left(f_today(),4))



end event

type p_exit from w_standard_dw_graph`p_exit within w_sal_05700
end type

type p_print from w_standard_dw_graph`p_print within w_sal_05700
end type

type p_retrieve from w_standard_dw_graph`p_retrieve within w_sal_05700
end type

type st_window from w_standard_dw_graph`st_window within w_sal_05700
end type

type st_popup from w_standard_dw_graph`st_popup within w_sal_05700
end type

type pb_title from w_standard_dw_graph`pb_title within w_sal_05700
end type

type pb_space from w_standard_dw_graph`pb_space within w_sal_05700
end type

type pb_color from w_standard_dw_graph`pb_color within w_sal_05700
end type

type pb_graph from w_standard_dw_graph`pb_graph within w_sal_05700
end type

type dw_ip from w_standard_dw_graph`dw_ip within w_sal_05700
integer x = 41
integer width = 3959
integer height = 296
string dataobject = "d_sal_05700_01"
end type

event dw_ip::itemchanged;string s_name,sIttyp, snull, get_nm
string sArea, sTeam, sCvcod, sCvcodnm

Choose Case  GetColumnName() 
	Case 'itcls'
		s_name = Trim(this.gettext())
      sIttyp = GetItemString(1,'ittyp')
      IF s_name = "" OR IsNull(s_name) THEN 	
		   This.setitem(1, 'itclsnm', snull)
		   RETURN 
	   END IF
	
      SELECT "ITNCT"."TITNM"
        INTO :get_nm
        FROM "ITNCT"  
       WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
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
/* 영업팀 */
  Case "steam"
	 SetItem(1,'sarea',snull)
	 SetItem(1,'cvcod',snull)
	 SetItem(1,'cvcodnm',snull)
/* 관할구역 */		
  Case "sarea"
	 sArea = this.GetText()
 	 SetItem(1,'cvcod',snull)
	 SetItem(1,'cvcodnm',snull)
	 IF sArea = "" OR IsNull(sArea) THEN RETURN
	
	 SELECT "SAREA"."SAREA", "SAREA"."STEAMCD" INTO :sArea, :sTeam
		FROM "SAREA"  
	  WHERE "SAREA"."SAREA" = :sArea  ;
	 IF SQLCA.SQLCODE <> 0 THEN
		f_message_chk(33,'[관할구역]')
		this.SetItem(1,"sarea",snull)
		Return 1
	 END IF
	 
	 this.SetItem(1,"steam",  sTeam)
/* 거래처 */
  Case "cvcod"
	 sCvcod = this.GetText()
	 IF sCvcod ="" OR IsNull(sCvcod) THEN
		this.SetItem(1,"cvcodnm",snull)
		Return
	 END IF
	
	 SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
	   INTO :sCvcodnm,		:sArea,			:sTeam
	   FROM "VNDMST","SAREA" 
     WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :sCvcod   ;
	 IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN
			this.SetItem(1,"cvcod",snull)
			this.SetItem(1,"cvcodnm",snull)
		END IF
		Return 1
	ELSE
		this.SetItem(1,"steam",  sTeam)
		this.SetItem(1,"sarea",  sArea)
		this.SetItem(1,"cvcodnm",sCvcodnm)
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
	sIttyp = '1'
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if

IF this.GetColumnName() ="cvcod" THEN
	gs_gubun = '1'
	Open(w_vndmst_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"cvcod",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

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

type sle_msg from w_standard_dw_graph`sle_msg within w_sal_05700
end type

type dw_datetime from w_standard_dw_graph`dw_datetime within w_sal_05700
end type

type st_10 from w_standard_dw_graph`st_10 within w_sal_05700
end type

type gb_3 from w_standard_dw_graph`gb_3 within w_sal_05700
end type

type dw_list from w_standard_dw_graph`dw_list within w_sal_05700
integer y = 332
integer height = 1984
string dataobject = "d_sal_05700"
end type

type gb_10 from w_standard_dw_graph`gb_10 within w_sal_05700
end type

type rr_1 from w_standard_dw_graph`rr_1 within w_sal_05700
integer y = 320
integer height = 2016
end type

