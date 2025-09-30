$PBExportHeader$w_ktxb03.srw
$PBExportComments$접대비명세서 조회 출력
forward
global type w_ktxb03 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxb03
end type
end forward

global type w_ktxb03 from w_standard_print
integer x = 0
integer y = 0
string title = "접대비명세서 조회 출력"
rr_1 rr_1
end type
global w_ktxb03 w_ktxb03

type variables
String prt_gu

end variables

forward prototypes
public function integer wf_jub_jichul ()
public function integer wf_jub_chong (string sdate_fm, string sdate_to, string sji_gu)
public function integer wf_retrieve ()
end prototypes

public function integer wf_jub_jichul ();String   sdate,   &
			edate,   &
			ssano,   &
			suptae,  &
			sjongk,  &
			sownam,  &
			saddr1,  &
			scvnas,  &
			saupj,   &
			srcvmg

Double   djub_tot1,  &
         djub_count1,&
			djub_tot2,  &
			djub_count2,&
			djub_tot3,  &
			djub_count3,& 
			djub_tot4,  &
			djub_count4,&
			djub_tot5,  &
			djub_count5,&
			djub_tot6,  &
			djub_count6,&
         djub_tot7,  &
			djub_count7,&
			djub_tot8,  &
			djub_count8,&
			djub_tot9,  &
			djub_count9,&
			tot_jub_amt,&
			tot_jub_cnt

sle_msg.text =""

sdate  = dw_ip.GetItemString(1,"sdate")
edate  = dw_ip.GetItemString(1,"edate")

dw_list.Reset()
dw_list.InsertRow(0)

dw_list.SetRedraw(False)
SELECT "VNDMST"."SANO", "VNDMST"."UPTAE", "VNDMST"."JONGK",   
       "VNDMST"."OWNAM", "VNDMST"."ADDR1", "VNDMST"."CVNAS", "VNDMST"."RCVMG"   
	INTO :ssano, :suptae, :sjongk, :sownam, :saddr1, :scvnas , :srcvmg 
   FROM "VNDMST","SYSCNFG"  
   WHERE "VNDMST"."CVCOD" = SUBSTR("SYSCNFG"."DATANAME",1,6) AND
			"SYSCNFG"."SYSGU" = 'C' AND
			"SYSCNFG"."SERIAL" = 4 AND "SYSCNFG"."LINENO" = '1';

setpointer(hourglass!)

DECLARE save_junpyo CURSOR FOR 
	select a.jub_tot1, a.jub_count1, b.jub_tot2, b.jub_count2, c.jub_tot3, c.jub_count3,
          d.jub_tot4, d.jub_count4, e.jub_tot5, e.jub_count5, f.jub_tot6, f.jub_count6,
			 g.jub_tot7, g.jub_count7, h.jub_tot8, h.jub_count8, i.jub_tot9, i.jub_count9
     from (select nvl(sum(jub_amt),0) as jub_tot1, count(jub_amt) as jub_count1
             from kfz15ot0 
            where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and
						alc_gu = 'Y' ) a,  //접대비 발생액(+기밀비 )=실 접대비 발생액 
          (select nvl(sum(amt),0) as jub_tot2, count(amt) as jub_count2
             from kfz10ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						acc1_cd = '00000' ) b, //기밀비 
          (select nvl(sum(jub_amt),0) as jub_tot3, count(jub_amt) as jub_count3
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu = '1' and
						jub_gu = '2' and
						alc_gu = 'Y' ) c,   //신용카드거래분에서 일반접대비  
          (select nvl(sum(jub_amt),0) as jub_tot4, count(jub_amt) as jub_count4
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu = '2' and
						jub_gu = '2' and
						alc_gu = 'Y' ) d,  //신용카드거래분에서 해외접대비  
          (select nvl(sum(jub_amt),0) as jub_tot5, count(jub_amt) as jub_count5
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu = '1' and
						jub_gu = '4' and
						alc_gu = 'Y' ) e,  //세금계산서거래분에서 일반접대비  
          (select nvl(sum(jub_amt),0) as jub_tot6, count(jub_amt) as jub_count6
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu = '2' and
						jub_gu = '4' and
						alc_gu = 'Y' ) f,  //세금계산서거래분에서 해외접대비  
          (select nvl(sum(jub_amt),0) as jub_tot7, count(jub_amt) as jub_count7
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu <> '2' and
						jub_gu = '3' and
						alc_gu = 'Y' ) g,  //소액 접대비  (해외접대비 제외)
		    (select nvl(sum(jub_amt),0) as jub_tot8, count(jub_amt) as jub_count8
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_jigu = '2' and
						jub_gu <> '2' and
						jub_gu <> '4' and
						alc_gu = 'Y' ) h,  //국외 지출접대비 
		    (select nvl(sum(jub_amt),0) as jub_tot9, count(jub_amt) as jub_count9
             from kfz15ot0 
				where saupj >= :sabu_f and
                  saupj <= :sabu_t and
                  acc_date >= :sdate and  
                  acc_date <= :edate and 
						jub_gu = '1' and
						alc_gu = 'Y' ) i;   //명세서 지출대상

OPEN save_junpyo;

FETCH save_junpyo 
	INTO 	:djub_tot1, :djub_count1, :djub_tot2, :djub_count2, :djub_tot3, :djub_count3,
         :djub_tot4, :djub_count4, :djub_tot5, :djub_count5, :djub_tot6, :djub_count6,
	      :djub_tot7, :djub_count7, :djub_tot8, :djub_count8, :djub_tot9, :djub_count9;	    

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	CLOSE save_junpyo;
	Return -1
END IF

tot_jub_amt = djub_tot1 + djub_tot2
tot_jub_cnt = djub_count1 + djub_count2
			
dw_list.SetItem(1,"saupno",ssano)
dw_list.SetItem(1,"sano",srcvmg)
dw_list.SetItem(1,"upjong",sjongk)
dw_list.SetItem(1,"owner",sownam)
dw_list.SetItem(1,"cust",scvnas)
dw_list.SetItem(1,"addr",saddr1)

dw_list.SetItem(1,"sdate",sdate) 
dw_list.SetItem(1,"edate",edate) 

dw_list.SetItem(1,"tot_cnt",tot_jub_cnt)
dw_list.SetItem(1,"tot_amt",tot_jub_amt)
dw_list.SetItem(1,"card_cnt1",djub_count3)
dw_list.SetItem(1,"card_amt1",djub_tot3)
dw_list.SetItem(1,"card_cnt2",djub_count4)
dw_list.SetItem(1,"card_amt2",djub_tot4)
dw_list.SetItem(1,"segum_cnt1",djub_count5)
dw_list.SetItem(1,"segum_amt1",djub_tot5)
dw_list.SetItem(1,"segum_cnt2",djub_count6)
dw_list.SetItem(1,"segum_amt2",djub_tot6)
dw_list.SetItem(1,"j10_cnt",djub_count7)
dw_list.SetItem(1,"j10_amt",djub_tot7)
dw_list.SetItem(1,"j11_cnt",djub_count2)
dw_list.SetItem(1,"j11_amt",djub_tot2)
dw_list.SetItem(1,"j12_cnt",djub_count8)
dw_list.SetItem(1,"j12_amt",djub_tot8)
dw_list.SetItem(1,"j14_cnt",djub_count9)
dw_list.SetItem(1,"j14_amt",djub_tot9)

dw_print.SetItem(1,"saupno",ssano)
dw_print.SetItem(1,"sano",srcvmg)
dw_print.SetItem(1,"upjong",sjongk)
dw_print.SetItem(1,"owner",sownam)
dw_print.SetItem(1,"cust",scvnas)
dw_print.SetItem(1,"addr",saddr1)

dw_print.SetItem(1,"sdate",sdate) 
dw_print.SetItem(1,"edate",edate) 

dw_print.SetItem(1,"tot_cnt",tot_jub_cnt)
dw_print.SetItem(1,"tot_amt",tot_jub_amt)
dw_print.SetItem(1,"card_cnt1",djub_count3)
dw_print.SetItem(1,"card_amt1",djub_tot3)
dw_print.SetItem(1,"card_cnt2",djub_count4)
dw_print.SetItem(1,"card_amt2",djub_tot4)
dw_print.SetItem(1,"segum_cnt1",djub_count5)
dw_print.SetItem(1,"segum_amt1",djub_tot5)
dw_print.SetItem(1,"segum_cnt2",djub_count6)
dw_print.SetItem(1,"segum_amt2",djub_tot6)
dw_print.SetItem(1,"j10_cnt",djub_count7)
dw_print.SetItem(1,"j10_amt",djub_tot7)
dw_print.SetItem(1,"j11_cnt",djub_count2)
dw_print.SetItem(1,"j11_amt",djub_tot2)
dw_print.SetItem(1,"j12_cnt",djub_count8)
dw_print.SetItem(1,"j12_amt",djub_tot8)
dw_print.SetItem(1,"j14_cnt",djub_count9)
dw_print.SetItem(1,"j14_amt",djub_tot9)


CLOSE save_junpyo;

dw_list.SetRedraw(True)
setpointer(arrow!)    

Return 1
end function

public function integer wf_jub_chong (string sdate_fm, string sdate_to, string sji_gu);Int il_cursor_cnt,&
    il_insert_row=1,&
	 i,&
	 ll_cnt[4],&
	 ll_tot_cnt
String ls_mon,&
       ls_jub_gu[4] ={"1","2","3","4"}, ls_jigu 
Double jub_amt[4],ldb_tot_amt

DECLARE save_mon CURSOR FOR
  	SELECT DISTINCT SUBSTR("KFZ15OT0"."BIL_DATE",5,2), "KFZ15OT0"."JUB_JIGU"
   	FROM "KFZ15OT0"  
   	WHERE ( "KFZ15OT0"."SAUPJ" >= :sabu_f ) AND  
         	( "KFZ15OT0"."SAUPJ" <= :sabu_t ) AND  
         	( "KFZ15OT0"."ACC_DATE" >= :sdate_fm ) AND  
         	( "KFZ15OT0"."ACC_DATE" <= :sdate_to ) AND
		      ( "KFZ15OT0"."JUB_JIGU" like :sji_gu ) 
   ORDER BY SUBSTR("KFZ15OT0"."BIL_DATE",5,2) ASC;

OPEN save_mon;

il_cursor_cnt =1
ldb_tot_amt =0
ll_tot_cnt =0

dw_list.Reset()

DO WHILE true
	FETCH save_mon INTO :ls_mon, :ls_jigu;

	IF SQLCA.SQLCODE <> 0 THEN exit	
	
	dw_list.InsertRow(0)
	
	FOR i =1 TO 4
		SELECT SUM("KFZ15OT0"."JUB_AMT"),   
         	 COUNT("KFZ15OT0"."SEQ_NO")  
    	INTO :jub_amt[i],   
           :ll_cnt[i]  
    	FROM "KFZ15OT0"  
   	WHERE ( "KFZ15OT0"."SAUPJ" >= :sabu_f ) AND  
         	( "KFZ15OT0"."SAUPJ" <= :sabu_t ) AND  
         	( "KFZ15OT0"."ACC_DATE" >= :sdate_fm) AND  
         	( "KFZ15OT0"."ACC_DATE" <= :sdate_to ) AND
				( SUBSTR("KFZ15OT0"."BIL_DATE",5,2) =:ls_mon ) AND
         	( "KFZ15OT0"."JUB_JIGU" like :ls_jigu ) AND //sji_gu
            ( "KFZ15OT0"."JUB_GU" = :ls_jub_gu[i] );
		IF IsNull(jub_amt[i]) THEN
			jub_amt[i] =0
		END IF
		IF IsNull(ll_cnt[i]) THEN
			ll_cnt[i] =0
		END IF
		IF i = 1 THEN
		ELSE
			ldb_tot_amt +=jub_amt[i]
			ll_tot_cnt +=ll_cnt[i]
		END IF
	NEXT  
	
	IF jub_amt[1] =0 AND ldb_tot_amt =0 THEN
		dw_list.DeleteRow(0)
	ELSE
		IF sabu_f ="1" and sabu_t="98" THEN
			dw_list.SetItem(il_insert_row,"saupj","전체")
			dw_print.SetItem(il_insert_row,"saupj","전체")
		else 
			dw_list.SetItem(il_insert_row,"saupj",sabu_f)
			dw_print.SetItem(il_insert_row,"saupj",sabu_f)
	   END IF
		IF ls_jigu = "1" THEN
			dw_list.SetItem(il_insert_row,"jub_jigu","국내")
			dw_print.SetItem(il_insert_row,"jub_jigu","국내")
		elseif ls_jigu = "2" THEN
			dw_list.SetItem(il_insert_row,"jub_jigu","해외")
			dw_print.SetItem(il_insert_row,"jub_jigu","해외")
		END IF
		
		dw_list.SetItem(il_insert_row,"sdate",sdate_fm)
		dw_list.SetItem(il_insert_row,"edate",sdate_to)

		dw_list.SetItem(il_insert_row,"bil_mm",ls_mon)
		dw_list.SetItem(il_insert_row,"hmoney_amt",jub_amt[1])
		dw_list.SetItem(il_insert_row,"hmoney_nbr",ll_cnt[1])
		dw_list.SetItem(il_insert_row,"card_amt",jub_amt[2])
		dw_list.SetItem(il_insert_row,"card_nbr",ll_cnt[2])
		dw_list.SetItem(il_insert_row,"smoney_amt",jub_amt[3])
		dw_list.SetItem(il_insert_row,"smoney_nbr",ll_cnt[3])
		dw_list.SetItem(il_insert_row,"txt_amt",jub_amt[4])
		dw_list.SetItem(il_insert_row,"txt_nbr",ll_cnt[4])
		dw_list.SetItem(il_insert_row,"tot_amt",ldb_tot_amt)
		dw_list.SetItem(il_insert_row,"tot_nbr",ll_tot_cnt)
		
		dw_print.SetItem(il_insert_row,"sdate",sdate_fm)
		dw_print.SetItem(il_insert_row,"edate",sdate_to)

		dw_print.SetItem(il_insert_row,"bil_mm",ls_mon)
		dw_print.SetItem(il_insert_row,"hmoney_amt",jub_amt[1])
		dw_print.SetItem(il_insert_row,"hmoney_nbr",ll_cnt[1])
		dw_print.SetItem(il_insert_row,"card_amt",jub_amt[2])
		dw_print.SetItem(il_insert_row,"card_nbr",ll_cnt[2])
		dw_print.SetItem(il_insert_row,"smoney_amt",jub_amt[3])
		dw_print.SetItem(il_insert_row,"smoney_nbr",ll_cnt[3])
		dw_print.SetItem(il_insert_row,"txt_amt",jub_amt[4])
		dw_print.SetItem(il_insert_row,"txt_nbr",ll_cnt[4])
		dw_print.SetItem(il_insert_row,"tot_amt",ldb_tot_amt)
		dw_print.SetItem(il_insert_row,"tot_nbr",ll_tot_cnt)
		il_insert_row +=1
	END IF
	FOR i =1 TO 4
		jub_amt[i] =0
		ll_cnt[i] =0
	NEXT
	ldb_tot_amt =0
	ll_tot_cnt =0
	il_cursor_cnt +=1
LOOP

CLOSE save_mon;

if il_insert_row < 2 then 
	f_messagechk(11,"")
	return -1
end if

SetPointer(Arrow!)

Return 1
end function

public function integer wf_retrieve ();//************************************************************************************//
String sdatef,sdatet,sSaupj,sSelectGbn

dw_ip.AcceptText()

w_mdi_frame.sle_msg.text =""

sSaupj  = Trim(dw_ip.GetItemString(1,"saupj"))
sdatef  = Trim(dw_ip.GetItemString(1,"sdate"))
sdatet  = Trim(dw_ip.GetItemString(1,"edate"))
sSaupj  = dw_ip.GetItemString(1,"saupj")
sSelectgbn = dw_ip.GetItemString(1,"sselect_gu")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDatef = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDatet = "" OR IsNull(sDatet) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("edate")
	dw_ip.SetFocus()
	Return -1
END IF

IF DaysAfter(Date(sdatef),Date(sdatet)) < 0 THEN
	f_Messagechk(24,"") 
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF 

IF sSaupj = "99" THEN sSaupj = "%"

IF dw_print.Retrieve(sSaupj,sdatef,sdatet) <=0 THEN
	f_Messagechk(14,"")
	Return -1
END IF	

dw_print.sharedata(dw_list)

Return 1
end function

on w_ktxb03.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxb03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.GetRow(),"saupj", gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"sdate", left(f_today(), 6) + "01")
dw_ip.SetItem(dw_ip.Getrow(),"edate", f_today())
dw_ip.SetFocus()

dw_ip.Modify("saupj.protect = 0")
//dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
		


end event

type p_preview from w_standard_print`p_preview within w_ktxb03
integer x = 4082
integer y = 8
integer taborder = 30
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_ktxb03
integer x = 4425
integer y = 8
integer taborder = 50
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxb03
integer x = 4256
integer y = 8
integer taborder = 40
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxb03
integer x = 3909
integer y = 8
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_ktxb03
end type



type dw_print from w_standard_print`dw_print within w_ktxb03
string dataobject = "dw_ktxb033_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxb03
integer x = 59
integer y = 24
integer width = 3515
integer height = 136
string dataobject = "dw_ktxb031"
end type

event dw_ip::itemchanged;
IF dwo.name = "sselect_gu" THEN
	CHOOSE CASE data
		
		CASE '2'
			dw_list.DataObject ="dw_ktxb033"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_ktxb033_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
			
		CASE '3'

			dw_list.DataObject ="dw_ktxb034"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			
			dw_print.DataObject ="dw_ktxb034_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
	END CHOOSE
	w_mdi_frame.sle_msg.text =""
END IF

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_ktxb03
integer x = 73
integer y = 172
integer width = 4517
integer height = 2020
string dataobject = "dw_ktxb033"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_ktxb03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 168
integer width = 4530
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

