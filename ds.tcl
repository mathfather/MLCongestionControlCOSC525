#set sortie_avec_apprentissage [open fichier_sortie_avec_apprentissage a+] 
#set sortie_sans_apprentissage [open  fichier_tcp_sans_apprentissage a+]
source "topology_finish.tcl"

set tot 0
set totpack 0
Agent/TCP set rtxcur_init_ 1
proc dequeuter_liste {list} {
    set list_ {}
    for {set i 0 } {$i < [expr  [llength $list] - 1] } {incr i} {
	
	set list_ "$list_ [lindex $list $i]"
    }
    
    return $list_
}
set file [open les-pertes-tcp.txt w] 
Class Agent/TCP/Newreno/Test -superclass Agent/TCP/Newreno

Agent/TCP instproc  average_sur_les_derniers_rtts {} { 
    $self instvar average_ list_time_ list_ averageinterpaquets_ averageinterpaquets2_ ecart_type_ ecart_typeinterpaquets_
    global ns
    set sum_(1) 0
    set sum_(2) 0
    set sum_(3) 0
    set nbre_(1) 0
    set nbre_(2) 0
    set nbre_(3) 0
    set average_(1) 0
    set average_(2) 0
    set average_(3) 0
    set averageinterpaquets2_(1) 0
    set averageinterpaquets2_(2) 0
    set averageinterpaquets2_(3) 0
    set averageinterpaquets_(1) 0
    set averageinterpaquets_(2) 0
    set averageinterpaquets_(3) 0
    set listtmp1 ""
    set listtmp2 ""
    set listtmp3 ""
    set ecart_typeinterpaquets_(1) 0
    set ecart_typeinterpaquets_(2) 0
    set ecart_typeinterpaquets_(3) 0
    set ecart_type_(1) 0
    set ecart_type_(2) 0 
    set ecart_type_(3) 0


    for {set i 0 } { $i < [llength $list_time_] } { incr i } {
	if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr [$self set rtt_] * [$self set tcpTick_] ]} {
	    set sum_(1) [expr $sum_(1) + [lindex $list_ $i ]]
	    incr nbre_(1)
	    set average_(1) [expr  $sum_(1) /$nbre_(1)]
	    set listtmp1 "$listtmp1 [lindex $list_ $i ]"
	    set ecart_type_(1) [ecart_type $listtmp1]

	} else {
	    if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr 2* [$self set rtt_] * [$self set tcpTick_] ]} {
		set sum_(2) [expr $sum_(2) + [lindex $list_ $i ]]
		incr nbre_(2) 
		set average_(2) [expr  $sum_(2) /$nbre_(2)]
		set listtmp2 "$listtmp2 [lindex $list_ $i ]"
		set ecart_type_(2) [ecart_type $listtmp2]

	    } else {
		set sum_(3) [expr $sum_(3) + [lindex $list_ $i ]]
		incr nbre_(3) 
		set average_(3) [expr  $sum_(3) /$nbre_(3)]
		set listtmp3 "$listtmp3 [lindex $list_ $i ]"
		set ecart_type_(3) [ecart_type $listtmp3]

	    }
	}
    }
    set sum_(1) 0
    set sum_(2) 0
    set sum_(3) 0
    set nbre_(1) 0
    set nbre_(2) 0
    set nbre_(3) 0
    set listtmp1 ""
    set listtmp2 ""
    set listtmp3 ""

    for {set i 0 } { $i < [llength $list_time_] } { incr i } {
	if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr [$self set rtt_] * [$self set tcpTick_] ]} {
	    set sum_(1) [expr $sum_(1) + [lindex $list_ $i ]]
	    incr nbre_(1)
	    set averageinterpaquets_(1) [expr  $sum_(1) /$nbre_(1)]
	    set listtmp1  "$listtmp1 [lindex $list_time_ $i ]"
	    set ecart_typeinterpaquets_(1) [ecart_type $listtmp1]
	} else {
	    if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr 2* [$self set rtt_] * [$self set tcpTick_] ]} {
		set sum_(2) [expr $sum_(2) + [lindex $list_ $i ]]
		incr nbre_(2) 
		set averageinterpaquets_(2) [expr  $sum_(2) /$nbre_(2)]
		set listtmp2  "$listtmp2 [lindex $list_time_ $i ]"
		set ecart_typeinterpaquets_(2) [ecart_type $listtmp2]
	    } else {
		set sum_(3) [expr $sum_(3) + [lindex $list_ $i ]]
		incr nbre_(3) 
		set averageinterpaquets_(3) [expr  $sum_(3) /$nbre_(3)]
		set listtmp3  "$listtmp3 [lindex $list_time_ $i ]"
		set ecart_typeinterpaquets_(3) [ecart_type $listtmp3]
	    }
	}
    }
    set sum_(1) 0
    set sum_(2) 0
    set sum_(3) 0
    set nbre_(1) 0
    set nbre_(2) 0
    set nbre_(3) 0
    
    for {set i 0 } { $i < [llength $list_time_] } { incr i } {
	if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr [$self set rtt_] * [$self set tcpTick_] ]} {
	    set sum_(1) [expr $sum_(1) + [lindex $list_ $i ]]
	    incr nbre_(1)
	    set averageinterpaquets2_(1) [expr  $sum_(1) /$nbre_(1)]
	} else {
	    if { [expr [$ns now]- [lindex $list_time_ $i ]] <= [expr 2* [$self set rtt_] * [$self set tcpTick_] ]} {
		set sum_(2) [expr $sum_(2) + [lindex $list_ $i ]]
		incr nbre_(2) 
		set averageinterpaquets2_(2) [expr  $sum_(2) /$nbre_(2)]
	    } else {
		set sum_(3) [expr $sum_(3) + [lindex $list_ $i ]]
		incr nbre_(3) 
		set averageinterpaquets2_(3) [expr  $sum_(3) /$nbre_(3)]
		
	    }
	}
    }


}

Agent/TCP instproc slowdown {} {
    $self instvar last_cwnd dup
    set last_cwnd  [$self set cwnd_]
    
}
Agent/TCP instproc slowdown2 {} {
    $self instvar last_cwnd cwnd_
    global ns
    
    #    set cwnd_ [max 4 [expr  $last_cwnd / 2.0]]
    #  puts "last_cwnd $last_cwnd cwnd cwnd_ [$self  set cwnd_] "
}






Agent/TCP/Newreno/Test instproc recv_ {seqno ts_recu_ ts_envoye_ win } {
    $self instvar ecart_type_ last_win_ last_cwnd sum_ nbre reason_ list_  phase_de_retransmission premier_seqno_retransmis list_time_ demi_rtt_ coef last_lost_ average_ min_rtt_  set last_seqno_ liste_intermediaire last_recv last_send sortie lastack liste_des_duplicatas avant_dernier time derniere_cwnd_ intervalle_de_temps liste_inter_paquet  liste_inter_paquet2 liste_des_duplicatasinterpaquet liste_des_duplicatasinterpaquet2 averageinterpaquets2_ averageinterpaquets_ avant_dernierinterpaquet avant_dernierinterpaquet2 ecart_typeinterpaquets_ NBREPERTE

    global ns file

    if {![info exists last_win_ ]} {
	set last_cwnd [$self set cwnd_]
	set last_win_ $win
	set liste_intermediaire "$seqno"
	set coef 0.25
	set sum_ 0
	set min_rtt_  [$self set rtt_]
	set nbre 0
	set list_ ""
	set liste_inter_paquet ""
	set liste_inter_paquet2 ""
     	set last_lost_ 0 
	set list_time_ ""
	set last_recv $ts_recu_ 
	set last_send $ts_envoye_
	set demi_rtt_ [expr $coef *  ($ts_recu_ -  $ts_envoye_) ]
    }
    if {$min_rtt_ == 0 } {
	set  min_rtt_  [$self set rtt_]
    } else {
	set min_rtt_ [min  $min_rtt_  [$self set rtt_]]
    }
    

    if {[info exists liste_des_duplicatas] && [info exists avant_dernier] } {
	if { $seqno == $lastack} {
	    set liste_des_duplicatas "$liste_des_duplicatas [expr $ts_recu_ - $ts_envoye_] "
	    set liste_des_duplicatasinterpaquet "$liste_des_duplicatasinterpaquet [expr $ts_recu_ - $last_recv] "
	    set liste_des_duplicatasinterpaquet2 "$liste_des_duplicatasinterpaquet2 [expr $ts_recu_ - $last_recv -($ts_envoye_ - $last_send) ] "
	    
	} else {
	    if {[llength  $liste_des_duplicatas] > 0} {
		set NBREPERTE [expr $seqno - $premier_seqno_retransmis + 1]
		set result [$self test_C_A]
		if {$result == "A" && [ $self set cwnd_] < $last_cwnd} {
		    $self set cwnd_   $last_cwnd 
		#    puts "A"
		} else {
		 #   		    puts "C"
		}
	    }
	    unset liste_des_duplicatas
	    unset liste_des_duplicatasinterpaquet2
	    unset liste_des_duplicatasinterpaquet
	    unset avant_dernier
	    
	}
    }
    
    
    #return
    set demi_rtt_ [expr $coef *  ($ts_recu_ -  $ts_envoye_) + (1- $coef)* $demi_rtt_]
    set liste_intermediaire "$seqno $liste_intermediaire"
    while { [llength $list_time_] >= 4 && [expr [$ns now]-[lindex $list_time_ [expr [llength $list_time_]-1]]] >= [expr 3*[$self set rtt_] * [$self set tcpTick_] ]} {
	
	set liste_inter_paquet2 [dequeuter_liste $liste_inter_paquet2]
	set liste_inter_paquet [dequeuter_liste $liste_inter_paquet]
	set list_time_ [ dequeuter_liste $list_time_]
	set list_ [ dequeuter_liste $list_]
	set liste_intermediaire [ dequeuter_liste $liste_intermediaire ]
    }
    
    
    
    #   if {$last_win_ == $win } { cette condition est a a maintenir si on veut ne prendre en consideration que les paquets non retransmis. Nous l'avaons enleve car tres vite on est face a plus de retransmission qu'autre chose.
    set sum_ [expr $sum_ + $ts_recu_ - $ts_envoye_]
    incr nbre 
    set list_time_ "[$ns now] $list_time_"
    set list_ "[expr $ts_recu_ - $ts_envoye_] $list_"
    set liste_inter_paquet "[expr $ts_recu_ - $last_recv] $liste_inter_paquet"
    set liste_inter_paquet2 "[expr $ts_recu_ - $last_recv -($ts_envoye_ - $last_send) ] $liste_inter_paquet2"
    
    #  } 

    
    
    if {$reason_ != 0 } {

	
	$self  average_sur_les_derniers_rtts ; #cette fct ressort la moyenne sur les 3 derniers rtts   
	set intervalle_de_temps [expr [$ns now]- $last_lost_]

	if {$reason_ == 1 } {
	    #		puts  "[$ns now] timeout [$self set node_src] [$self set node_dst]  $premier_seqno_retransmis  $intervalle_de_temps nbre depaquets au vol [expr $last_seqno_  - [$self set ack_]] [$self set cwnd_] demi_rtt_  $demi_rtt_ average_(1) $average_(1) average_(2)  $average_(2) average_(3)  $average_(3)  list_0  [lindex $list_ 0] list_1 [lindex $list_ 1]  list_2 [lindex $list_ 2] list_3 [lindex $list_ 3] list_4 [lindex $list_ 4] list_5 [lindex $list_ 5] list_6 [lindex $list_ 6]  list_7 [lindex $list_ 7]   seqno $seqno t_seqno_ [$self set t_seqno_ ] ack [$self set ack_] win $win "
	    
	} else {
	    set intervalle_de_temps [expr [$ns now]- $last_lost_]
	    set time [$ns now]
	    set derniere_cwnd_ [$self set cwnd_]
	    set lastack  $seqno 
	    set liste_des_duplicatas  ""
	    set liste_des_duplicatasinterpaquet  ""
	    set liste_des_duplicatasinterpaquet2  ""
	    
	    for {set i  0 } { $i < [llength  $list_ ]} { incr i } {
		if {[lindex $liste_intermediaire $i] != [expr $premier_seqno_retransmis - 1 ] } {
		    set avant_dernier [lindex $list_ $i]
		    set avant_dernierinterpaquet [lindex $liste_inter_paquet $i]
		    set avant_dernierinterpaquet2 [lindex $liste_inter_paquet2 $i]
		    break
		}
		set liste_des_duplicatas "$liste_des_duplicatas  [lindex $list_ $i]"
		set liste_des_duplicatasinterpaquet  "$liste_des_duplicatasinterpaquet [lindex $liste_inter_paquet $i] "
		set liste_des_duplicatasinterpaquet2  "$liste_des_duplicatasinterpaquet2 [lindex $liste_inter_paquet2 $i] "
	    }
	    
	    
	    
	}
	# $intervalle_de_temps $reason_ [$self set cwnd_] $demi_rtt_ $average_(1) $average_(2) $average_(3) [expr [$self set cwnd_] *( 1 - ($min_rtt_/[$self set rtt_] ))] [lindex $list_ 0] [lindex $list_ 1]  [lindex $list_ 2]

	# puts "[$self set node_src] [$self set node_dst]  $premier_seqno_retransmis  $intervalle_de_temps $reason_ [$self set cwnd_] $demi_rtt_ $average_(1) $average_(2) $average_(3) [expr [$self set cwnd_] *( 1 - ($min_rtt_/[$self set rtt_] ))] [lindex $list_ 0] [lindex $list_ 1]  [lindex $list_ 2]"
	flush $file

    }
    set last_lost_ [$ns now]
    set reason_ 0
    set last_recv $ts_recu_ 
    set last_send $ts_envoye_


}












Topology instproc place_tcpnewreno_session { src dst when finish_time} {
    $self instvar ns node

    set tcpsrc [new Agent/TCP/Newreno]
    set ftp [$tcpsrc attach-source FTP]
    $ns attach-agent $node($src) $tcpsrc
    set tcpdst [new Agent/TCPSink]
    $ns attach-agent $node($dst) $tcpdst
    
    $ns connect $tcpsrc $tcpdst
    $ns at $when "$ftp start"
    $ns at [expr $finish_time - 0.2] "$ftp stop"
}





Agent/TCP instproc send2 { win reason} {
    global  ns 
    $self instvar reason_
    if {![info exists reason_ ]} {
	set reason_ 0
    }
    
    #    puts "[$ns now ] [$self set node_src] [$self set node_dst] t_seqno_  [$self set t_seqno_] win $win  highest_ack_ [$self set ack_]  high + win [expr [$self set ack_] + $win] reason $reason "

}


#source "algo.tcl"

Agent/TCP instproc newack {seqno ts_recu_ ts_envoye_} {
    global ns

} 






Agent/TCP instproc output {seqno reason win} {
    global ns finish_time good bad
    $self instvar timeout dup trans  last_win last_cwnd_ last_time_ reason_ phase_de_retransmission premier_seqno_retransmis highest_seqno last_seqno_ 
    
    if {![info exist timeout ]} {
	set timeout 0
	set dup 0
	set trans 0
	set last_win $win
	set last_time_ [$ns now]
	set highest_seqno 0
	set phase_de_retransmission 0
	set last_cwnd_ [$self set cwnd_]
	
    }
    set last_seqno_ $seqno 
    set highest_seqno [max $highest_seqno $seqno]
    if {$reason == 1 } {
	incr timeout
    }
    if {$reason == 2 } {
	incr dup
    }
    if {$reason == 0 } {
	incr trans
    }
    if {$seqno >= $highest_seqno  && $phase_de_retransmission == 1 } {
	set phase_de_retransmission 0    }
    
    if {$seqno < $highest_seqno  && $phase_de_retransmission == 0  } { # c'est qu'on est dans une phase de retransmission
	set phase_de_retransmission 1
	set premier_seqno_retransmis $seqno
	
    }
    if { $reason != 0 } {

	set reason_ $reason 
	
    } 
    if {$last_win != $win&& $last_cwnd_ != [$self set cwnd_]} {

	set last_time_ [$ns now]
    }
    
    set last_win $win
    set last_cwnd_ [$self set cwnd_]


    #    puts "[$ns now] [$self set node_src] [$self set node_dst] seqno $seqno $highest_seqno highest_ack_ [$self set ack_]  win  $win cwnd_ [$self set  cwnd_] reason $reason"
    
}




Topology instproc place_tcp_session { src dst when finish_time} {
    $self instvar ns node pktsize 
    
    global  argv tot totpack
    set tcpsrc [new Agent/TCP/Newreno]
    set ftp [$tcpsrc attach-source FTP]
    $ns attach-agent $node($src) $tcpsrc
    set tcpdst [new Agent/TCPSink]
    $ns attach-agent $node($dst) $tcpdst
    $tcpdst set node_dst $dst
    $tcpdst set node_src $src
    $ns connect $tcpsrc $tcpdst
    
    $ns at $when "$ftp start"
    
    $tcpsrc trace "cwnd_"
    $tcpsrc tracevar cwnd_
    #    $tcpsrc set fid_ 7
    $tcpsrc set node_dst $dst
    $tcpsrc set node_src $src
    #    $ns at [expr $finish_time - 0]  "puts \"dupack  \[$tcpsrc set dup\] timeout \[$tcpsrc set timeout\]\" "
    $ns at [expr $finish_time - 0] "set tot       \[expr  \$tot +  \[ $tcpsrc set  nackpack_\] \]"
    
    $ns at [expr $finish_time - 0] "set totpack       \[expr  \$totpack +  \[ $tcpsrc set  ndatapack_\] \]"  
    $ns at [expr $finish_time - 0] "puts \"Newreno [lindex $argv  0] [lindex $argv  1]ms pkt [lindex $argv  4]  [lindex $argv  2]Kb ndatapack_ \[ $tcpsrc set  ndatapack_\] nackpack_ \[ $tcpsrc set nackpack_ \]  dupack  \[$tcpsrc set dup\] timeout \[$tcpsrc set timeout\]  \$tot \$totpack\""
    $ns at [expr $finish_time - 0] "$ftp stop"
    
}




Topology instproc place_tcptest_session { src dst when finish_time} {
    $self instvar ns node pktsize 
    global  argv  tot totpack
    
    set tcpsrc [new Agent/TCP/Newreno/Test]
    set ftp [$tcpsrc attach-source FTP]
    $ns attach-agent $node($src) $tcpsrc
    set tcpdst [new Agent/TCPSink]
    $ns attach-agent $node($dst) $tcpdst
    $tcpdst set node_dst $dst
    $tcpdst set node_src $src
    $ns connect $tcpsrc $tcpdst
    
    $ns at $when "$ftp start"
    
    $tcpsrc trace "cwnd_"
    $tcpsrc tracevar cwnd_
    #    $tcpsrc set fid_ 7
    $tcpsrc set node_dst $dst
    $tcpsrc set node_src $src
    #     $ns at [expr $finish_time - 0]  "puts \"dupack   \[$tcpsrc set dup\] timeout \[$tcpsrc set timeout\]\" "
    
    $ns at [expr $finish_time - 0] "set tot       \[expr  \$tot +  \[ $tcpsrc set  nackpack_\] \]"
    $ns at [expr $finish_time - 0] "set totpack       \[expr  \$totpack +  \[ $tcpsrc set  ndatapack_\] \]"  
    $ns at [expr $finish_time - 0] "puts \"DT [lindex $argv  0] [lindex $argv  1]ms pkt [lindex $argv  4] [lindex $argv  2]Kb ndatapack_ \[ $tcpsrc set  ndatapack_\] nackpack_ \[ $tcpsrc set nackpack_ \]  dupack  \[$tcpsrc set dup\] timeout \[$tcpsrc set timeout\]  \$tot \$totpack\""
    $ns at [expr $finish_time - 0] "$ftp stop"
    
}


proc fct  {val moy std} {
    if {$std == 0} {
	return 1000000
    }
    return  [absolue ([expr 1.0 * ($val -$moy) / $std])]
}

Agent/TCP/Newreno/Test instproc test_C_A {} {
    global argv
    $self instvar  ecart_type_ last_win_ last_cwnd sum_ nbre reason_ list_  phase_de_retransmission premier_seqno_retransmis list_time_ demi_rtt_ coef last_lost_ average_ min_rtt_  set last_seqno_ liste_intermediaire last_recv last_send sortie lastack liste_des_duplicatas avant_dernier time derniere_cwnd_ intervalle_de_temps liste_inter_paquet  liste_inter_paquet2 liste_des_duplicatasinterpaquet liste_des_duplicatasinterpaquet2 averageinterpaquets2_ averageinterpaquets_ avant_dernierinterpaquet avant_dernierinterpaquet2 ecart_typeinterpaquets_ NBREPERTE 
 
    

    set P [lindex $argv 0]
    set AVG1_IP $averageinterpaquets_(1)
    set AVG2_IP $averageinterpaquets_(2)
    set AVGLDD_IP [moyenne_liste $liste_des_duplicatasinterpaquet]
    set STDLDD_IP [ecart_type $liste_des_duplicatasinterpaquet]
    if {[catch { set  STD1_IP $ecart_typeinterpaquets_(1)} ] } {
	set STD1_IP 0
	puts ".STD1_IP ecart_typeinterpaquets_(1) [info exists ecart_typeinterpaquets_(1)]"
    }
    if {[catch  { set STD1 $ecart_type_(1) }] }  {
	set STD1 0
	puts ". STD1 ecart_type_(1) [info exists ecart_type_(1)]"
    }
    if {[catch  { set  STD2_IP $ecart_typeinterpaquets_(2) }] }  {
	set  STD2_IP 0
	puts ". STD2_IP ecart_typeinterpaquets_(2) [info exists ecart_typeinterpaquets_(2)]"
    }
    if {[catch  { set STD2 $ecart_type_(2) }] }  {
	set STD2  0
	puts ". STD2 ecart_type_(2) [info exists ecart_type_(2)]"
    }
    set AVANT_DERNIER $avant_dernier
    set AVANT_DERNIER_IP $avant_dernierinterpaquet
    set AVG2 $average_(2)
    set AVG1 $average_(1)
    set AVGLDD [moyenne_liste $liste_des_duplicatas]
    set MINLDD [min_list $liste_des_duplicatas]
    set MAXLDD [max_list $liste_des_duplicatas]
    set MAXLDD_IP  [max_list $liste_des_duplicatasinterpaquet]
    set MINLDD_IP [min_list $liste_des_duplicatasinterpaquet]
    set DEMI_RTT $demi_rtt_
    set AVG1_IP $averageinterpaquets_(1)
    set AVG2_IP $averageinterpaquets_(2)
    set AVGLDD_IP [moyenne_liste $liste_des_duplicatasinterpaquet]
    set STDLDD_IP [ecart_type $liste_des_duplicatasinterpaquet]
    
    set AVANT_DERNIER $avant_dernier
    set AVG2 $average_(2)
    set AVG1 $average_(1)
    set AVGLDD [moyenne_liste $liste_des_duplicatas]
    set MINLDD [min_list $liste_des_duplicatas]
    set MAXLDD [max_list $liste_des_duplicatas]
    set MINLDD_IP [min_list $liste_des_duplicatasinterpaquet]
    set INTERVAL $intervalle_de_temps
    set RTT [$self set rtt_]
    set COND_VENO [expr  $derniere_cwnd_ *(1-($min_rtt_/[$self set rtt_]))]
  
  if {[catch {set FCT_AVGLDD_1IP [fct $AVGLDD_IP $AVG1_IP $STD1_IP ]}] } {
	
	set FCT_AVGLDD_1IP 0
    } 
if {[catch {set FCT_AVGLDD_1 [fct $AVGLDD $AVG1 $STD1 ]}] } {
	
	set FCT_AVGLDD_1 0
    } 
    if {[catch {set  FCT_AVANTDERNIER_1IP [fct $AVANT_DERNIER_IP $AVG1_IP $STD1_IP ]}] }  {
	set FCT_AVANTDERNIER_1IP  0
    }
    if {[catch {set  FCT_AVANTDERNIER_1 [fct $AVANT_DERNIER $AVG1  $STD1]}] }  {
	set FCT_AVANTDERNIER_1 0
    }
    if {[catch {set  FCT_AVANTDERNIER_2IP [fct $AVANT_DERNIER_IP $AVG2_IP $STD2_IP]}] }  {
	set FCT_AVANTDERNIER_2IP  0
    } 
    if {[catch {set  FCT_AVANTDERNIER_2 [fct $AVANT_DERNIER $AVG2 $STD2]}] }  {
	set FCT_AVANTDERNIER_2  0
    }
    if {[catch {set  FCT_AVANTDERNIER_LDDIP [fct $AVANT_DERNIER_IP $AVGLDD_IP $STDLDD_IP] }] }  {
	set FCT_AVANTDERNIER_2  0
    }
    if {[catch {set  FCT_AVANTDERNIER_LDD  [fct $AVANT_DERNIER $AVGLDD $STDLDD_IP] }] }  {
	set FCT_AVANTDERNIER_2  0
    }
    if {[catch {set  FCT_AVGLDD_2IP [fct $AVGLDD_IP $AVG2_IP  $STD2_IP]}] }  {
	set FCT_AVANTDERNIER_2  0
    }
    if {[catch {set  FCT_AVGLDD_2 [fct $AVGLDD $AVG2  $STD2]}] }  {
	set FCT_AVANTDERNIER_2  0
    }

    set   NBREPERTEDIVCWND [expr $NBREPERTE / $derniere_cwnd_+ 0 ]
    set MINRTT_ $min_rtt_
    set SRTT [$self set srtt_]
    #********************************************************
    #*****************   DEBUT ARBRE    *********************
    #********************************************************
    set ATT99 [expr $NBREPERTE + 0]
    set ATT98 [expr $NBREPERTEDIVCWND + 0]
    set ATT96 [expr $INTERVAL / $RTT + 0]
    set ATT94 [expr $AVANT_DERNIER / $DEMI_RTT + 0]
    set ATT93 [expr $AVANT_DERNIER / $AVGLDD + 0]
    set ATT92 [expr $AVANT_DERNIER / $MINLDD + 0]
    set ATT91 [expr $AVANT_DERNIER / $MAXLDD + 0]
    set ATT89 [expr $AVANT_DERNIER / $AVG1 + 0]
    set ATT88 [expr $AVANT_DERNIER / $AVG2 + 0]
    set ATT84 [expr $AVGLDD / $MINLDD + 0]
    set ATT83 [expr $AVGLDD / $MAXLDD + 0]
    set ATT81 [expr $AVGLDD / $AVG1 + 0]
    set ATT80 [expr $AVGLDD / $AVG2 + 0]
    set ATT77 [expr $MINLDD / $DEMI_RTT + 0]
    set ATT74 [expr $MINLDD / $AVG1 + 0]
    set ATT73 [expr $MINLDD / $AVG2 + 0]
    set ATT70 [expr $MAXLDD / $DEMI_RTT + 0]
    set ATT68 [expr $MAXLDD / $AVG1 + 0]
    set ATT67 [expr $MAXLDD / $AVG2 + 0]
    set ATT50 [expr $AVANT_DERNIER_IP / $AVGLDD_IP + 0]
    set ATT49 [expr $AVANT_DERNIER_IP / $MINLDD_IP + 0]
    set ATT48 [expr $AVANT_DERNIER_IP / $MAXLDD_IP + 0]
    set ATT46 [expr $AVANT_DERNIER_IP / $AVG1_IP + 0]
    set ATT45 [expr $AVANT_DERNIER_IP / $AVG2_IP + 0]
    set ATT28 [expr $MAXLDD_IP / $AVG1_IP + 0]
    set ATT27 [expr $MAXLDD_IP / $AVG2_IP + 0]
    set ATT13 [expr $COND_VENO + 0]
    set ATT1 [expr $RTT / $MINRTT_ + 0]
    set ATT14 [expr $RTT / $SRTT + 0]
    set ATT12 [expr $INTERVAL / $SRTT + 0]
    set ATT11 [expr $FCT_AVANTDERNIER_LDD + 0]
    set ATT10 [expr $FCT_AVANTDERNIER_1 + 0]
    set ATT9 [expr $FCT_AVANTDERNIER_2 + 0]
    set ATT8 [expr $FCT_AVGLDD_1 + 0]
    set ATT7 [expr $FCT_AVGLDD_2 + 0]
    set ATT6 [expr $FCT_AVANTDERNIER_LDDIP + 0]
    set ATT5 [expr $FCT_AVANTDERNIER_1IP + 0]
    set ATT4 [expr $FCT_AVANTDERNIER_2IP + 0]
    set ATT3 [expr $FCT_AVGLDD_1IP + 0]
    set ATT2 [expr $FCT_AVGLDD_2IP + 0]
    set l "0 0"
    proc add_list {l1 l2} {
	set new_l ""
	for {set i 0} {$i<[llength $l1]} {incr i} {
	    lappend new_l [expr [lindex $l1 $i]+[lindex $l2 $i]]
	}
	return $new_l
    }
   


set l "0 0"
proc add_list {l1 l2} {
    set new_l ""
    for {set i 0} {$i<[llength $l1]} {incr i} {
	lappend new_l [expr [lindex $l1 $i]+[lindex $l2 $i]]
    }
    return $new_l
}
if {$ATT3 < 1.712621} {
    if {$ATT98 < 0.306020} {
	if {$ATT88 < 1.014936} {
	    if {$ATT1 < 1.008504} {
		set l [add_list $l "0.876923 0.123077 "]
	    } else {
		if {$ATT74 < 0.973324} {
		    set l [add_list $l "0.096154 0.903846 "]
		} else {
		    set l [add_list $l "0.800000 0.200000 "]
		}
	    }
	} else {
	    if {$ATT46 < 0.123069} {
		set l [add_list $l "0.043880 0.956120 "]
	    } else {
		if {$ATT13 < 0.374474} {
		    if {$ATT7 < 2.095351} {
			if {$ATT2 < 1.856051} {
			    set l [add_list $l "1.000000 0.000000 "]
			} else {
			    set l [add_list $l "0.200000 0.800000 "]
			}
		    } else {
			set l [add_list $l "0.000000 1.000000 "]
		    }
		} else {
		    set l [add_list $l "0.000000 1.000000 "]
		}
	    }
	}
    } else {
	if {$ATT13 < 2.205254} {
	    if {$ATT88 < 1.011634} {
		if {$ATT94 < 1.048813} {
		    if {$ATT89 < 1.168944} {
			set l [add_list $l "0.975906 0.024094 "]
		    } else {
			if {$ATT8 < 0.235536} {
			    set l [add_list $l "1.000000 0.000000 "]
			} else {
			    set l [add_list $l "0.272727 0.727273 "]
			}
		    }
		} else {
		    if {$ATT48 < 0.043099} {
			set l [add_list $l "0.117647 0.882353 "]
		    } else {
			if {$ATT7 < 2.654902} {
			    set l [add_list $l "0.936170 0.063830 "]
			} else {
			    if {$ATT67 < 1.018165} {
				if {$ATT83 < 0.951566} {
				    set l [add_list $l "0.850000 0.150000 "]
				} else {
				    set l [add_list $l "0.000000 1.000000 "]
				}
			    } else {
				set l [add_list $l "0.000000 1.000000 "]
			    }
			}
		    }
		}
	    } else {
		if {$ATT99 < 15.500000} {
		    if {$ATT49 < 1.056344} {
			if {$ATT49 < 0.938555} {
			    if {$ATT3 < 0.794715} {
				set l [add_list $l "1.000000 0.000000 "]
			    } else {
				if {$ATT91 < 0.973593} {
				    set l [add_list $l "0.692308 0.307692 "]
				} else {
				    set l [add_list $l "0.178571 0.821429 "]
				}
			    }
			} else {
			    if {$ATT6 < 1.606014} {
				if {$ATT96 < 0.005057} {
				    if {$ATT93 < 1.039106} {
					set l [add_list $l "1.000000 0.000000 "]
				    } else {
					set l [add_list $l "0.142857 0.857143 "]
				    }
				} else {
				    if {$ATT81 < 0.922436} {
					if {$ATT11 < 1.938962} {
					    set l [add_list $l "0.000000 1.000000 "]
					} else {
					    if {$ATT81 < 0.917237} {
						set l [add_list $l "0.923077 0.076923 "]
					    } else {
						set l [add_list $l "0.000000 1.000000 "]
					    }
					}
				    } else {
					if {$ATT6 < 0.264147} {
					    set l [add_list $l "0.250000 0.750000 "]
					} else {
					    if {$ATT98 < 0.428334} {
						if {$ATT89 < 1.014898} {
						    set l [add_list $l "0.000000 1.000000 "]
						} else {
						    set l [add_list $l "0.941176 0.058824 "]
						}
					    } else {
						if {$ATT45 < 0.030201} {
						    if {$ATT74 < 0.978819} {
							if {$ATT67 < 1.026500} {
							    set l [add_list $l "1.000000 0.000000 "]
							} else {
							    if {$ATT89 < 1.031577} {
								set l [add_list $l "0.642857 0.357143 "]
							    } else {
								set l [add_list $l "0.117647 0.882353 "]
							    }
							}
						    } else {
							set l [add_list $l "1.000000 0.000000 "]
						    }
						} else {
						    set l [add_list $l "0.963124 0.036876 "]
						}
					    }
					}
				    }
				}
			    } else {
				set l [add_list $l "0.111111 0.888889 "]
			    }
			}
		    } else {
			if {$ATT91 < 1.006866} {
			    if {$ATT98 < 1.937500} {
				if {$ATT1 < 1.005741} {
				    if {$ATT46 < 0.053552} {
					if {$ATT84 < 1.022756} {
					    set l [add_list $l "0.875000 0.125000 "]
					} else {
					    set l [add_list $l "0.047619 0.952381 "]
					}
				    } else {
					if {$ATT73 < 0.999974} {
					    if {$ATT84 < 1.225248} {
						if {$ATT50 < 0.378260} {
						    if {$ATT10 < 1.183239} {
							set l [add_list $l "0.200000 0.800000 "]
						    } else {
							set l [add_list $l "1.000000 0.000000 "]
						    }
						} else {
						    set l [add_list $l "0.923077 0.076923 "]
						}
					    } else {
						set l [add_list $l "0.200000 0.800000 "]
					    }
					} else {
					    set l [add_list $l "0.222222 0.777778 "]
					}
				    }
				} else {
				    if {$ATT4 < 1.635128} {
					if {$ATT12 < 0.129240} {
					    set l [add_list $l "0.186047 0.813954 "]
					} else {
					    if {$ATT3 < 1.439394} {
						set l [add_list $l "1.000000 0.000000 "]
					    } else {
						if {$ATT84 < 1.065764} {
						    set l [add_list $l "0.000000 1.000000 "]
						} else {
						    set l [add_list $l "0.666667 0.333333 "]
						}
					    }
					}
				    } else {
					set l [add_list $l "0.037736 0.962264 "]
				    }
				}
			    } else {
				if {$ATT96 < 0.025440} {
				    if {$ATT74 < 0.976667} {
					if {$ATT89 < 0.989622} {
					    set l [add_list $l "1.000000 0.000000 "]
					} else {
					    if {$ATT68 < 1.019732} {
						set l [add_list $l "0.800000 0.200000 "]
					    } else {
						set l [add_list $l "0.158730 0.841270 "]
					    }
					}
				    } else {
					set l [add_list $l "0.916667 0.083333 "]
				    }
				} else {
				    if {$ATT2 < 5.919315} {
					if {$ATT80 < 0.889874} {
					    set l [add_list $l "0.100000 0.900000 "]
					} else {
					    if {$ATT81 < 1.060797} {
						if {$ATT73 < 1.055066} {
						    if {$ATT48 < 0.235265} {
							if {$ATT1 < 1.220037} {
							    if {$ATT9 < 11.465111} {
								if {$ATT49 < 3.169233} {
								    if {$ATT8 < 0.451777} {
									set l [add_list $l "0.854701 0.145299 "]
								    } else {
									if {$ATT99 < 13.500000} {
									    if {$ATT48 < 0.216843} {
										if {$ATT48 < 0.038046} {
										    set l [add_list $l "0.250000 0.750000 "]
										} else {
										    set l [add_list $l "0.783784 0.216216 "]
										}
									    } else {
										set l [add_list $l "0.000000 1.000000 "]
									    }
									} else {
									    set l [add_list $l "0.000000 1.000000 "]
									}
								    }
								} else {
								    if {$ATT12 < 0.125240} {
									if {$ATT92 < 1.036069} {
									    set l [add_list $l "1.000000 0.000000 "]
									} else {
									    set l [add_list $l "0.133333 0.866667 "]
									}
								    } else {
									set l [add_list $l "0.857143 0.142857 "]
								    }
								}
							    } else {
								set l [add_list $l "0.000000 1.000000 "]
							    }
							} else {
							    set l [add_list $l "0.230769 0.769231 "]
							}
						    } else {
							set l [add_list $l "0.890351 0.109649 "]
						    }
						} else {
						    if {$ATT27 < 1.175606} {
							if {$ATT14 < 0.030545} {
							    set l [add_list $l "0.178571 0.821429 "]
							} else {
							    set l [add_list $l "1.000000 0.000000 "]
							}
						    } else {
							set l [add_list $l "1.000000 0.000000 "]
						    }
						}
					    } else {
						set l [add_list $l "1.000000 0.000000 "]
					    }
					}
				    } else {
					set l [add_list $l "0.250000 0.750000 "]
				    }
				}
			    }
			} else {
			    set l [add_list $l "0.950000 0.050000 "]
			}
		    }
		} else {
		    if {$ATT91 < 0.924127} {
			set l [add_list $l "0.938775 0.061224 "]
		    } else {
			if {$ATT84 < 1.010970} {
			    if {$ATT88 < 1.035075} {
				set l [add_list $l "0.962963 0.037037 "]
			    } else {
				if {$ATT6 < 0.292486} {
				    set l [add_list $l "0.000000 1.000000 "]
				} else {
				    set l [add_list $l "0.833333 0.166667 "]
				}
			    }
			} else {
			    if {$ATT96 < 0.017699} {
				set l [add_list $l "0.035714 0.964286 "]
			    } else {
				if {$ATT5 < 1.750573} {
				    if {$ATT49 < 1.001408} {
					if {$ATT46 < 0.051139} {
					    if {$ATT88 < 1.017385} {
						set l [add_list $l "1.000000 0.000000 "]
					    } else {
						set l [add_list $l "0.214286 0.785714 "]
					    }
					} else {
					    set l [add_list $l "0.944444 0.055556 "]
					}
				    } else {
					if {$ATT88 < 1.014570} {
					    set l [add_list $l "1.000000 0.000000 "]
					} else {
					    set l [add_list $l "0.175676 0.824324 "]
					}
				    }
				} else {
				    set l [add_list $l "0.000000 1.000000 "]
				}
			    }
			}
		    }
		}
	    }
	} else {
	    if {$ATT89 < 0.994967} {
		if {$ATT28 < 0.410944} {
		    set l [add_list $l "0.937500 0.062500 "]
		} else {
		    set l [add_list $l "0.000000 1.000000 "]
		}
	    } else {
		if {$ATT96 < 0.067740} {
		    set l [add_list $l "0.048193 0.951807 "]
		} else {
		    if {$ATT73 < 0.938914} {
			set l [add_list $l "0.111111 0.888889 "]
		    } else {
			set l [add_list $l "0.875000 0.125000 "]
		    }
		}
	    }
	}
    }
} else {
    if {$ATT13 < 0.345406} {
	if {$ATT98 < 0.392308} {
	    if {$ATT70 < 0.860857} {
		set l [add_list $l "0.714286 0.285714 "]
	    } else {
		set l [add_list $l "0.041963 0.958037 "]
	    }
	} else {
	    if {$ATT99 < 20.500000} {
		if {$ATT92 < 1.020545} {
		    if {$ATT77 < 0.999951} {
			if {$ATT80 < 1.009038} {
			    if {$ATT12 < 0.093645} {
				if {$ATT14 < 0.010229} {
				    set l [add_list $l "0.727273 0.272727 "]
				} else {
				    set l [add_list $l "0.000000 1.000000 "]
				}
			    } else {
				set l [add_list $l "0.987715 0.012285 "]
			    }
			} else {
			    if {$ATT98 < 1.477273} {
				if {$ATT48 < 0.495246} {
				    if {$ATT7 < 6753.469727} {
					if {$ATT28 < 0.194320} {
					    set l [add_list $l "0.073171 0.926829 "]
					} else {
					    if {$ATT68 < 1.026484} {
						set l [add_list $l "0.000000 1.000000 "]
					    } else {
						if {$ATT9 < 0.383069} {
						    set l [add_list $l "0.100000 0.900000 "]
						} else {
						    set l [add_list $l "0.806452 0.193548 "]
						}
					    }
					}
				    } else {
					set l [add_list $l "1.000000 0.000000 "]
				    }
				} else {
				    set l [add_list $l "0.789474 0.210526 "]
				}
			    } else {
				if {$ATT77 < 0.977564} {
				    if {$ATT89 < 0.001607} {
					set l [add_list $l "0.000000 1.000000 "]
				    } else {
					if {$ATT7 < 2948.785645} {
					    if {$ATT46 < 0.000622} {
						set l [add_list $l "0.166667 0.833333 "]
					    } else {
						if {$ATT10 < 2.886690} {
						    if {$ATT98 < 5.166667} {
							set l [add_list $l "0.895210 0.104790 "]
						    } else {
							if {$ATT7 < 1250.478271} {
							    set l [add_list $l "0.000000 1.000000 "]
							} else {
							    set l [add_list $l "1.000000 0.000000 "]
							}
						    }
						} else {
						    if {$ATT91 < 0.771190} {
							set l [add_list $l "1.000000 0.000000 "]
						    } else {
							if {$ATT27 < 0.839799} {
							    set l [add_list $l "0.000000 1.000000 "]
							} else {
							    set l [add_list $l "0.769231 0.230769 "]
							}
						    }
						}
					    }
					} else {
					    set l [add_list $l "0.991597 0.008403 "]
					}
				    }
				} else {
				    if {$ATT28 < 0.768479} {
					if {$ATT70 < 1.060491} {
					    set l [add_list $l "0.050000 0.950000 "]
					} else {
					    set l [add_list $l "0.800000 0.200000 "]
					}
				    } else {
					set l [add_list $l "0.857143 0.142857 "]
				    }
				}
			    }
			}
		    } else {
			if {$ATT49 < 1.750471} {
			    set l [add_list $l "0.035714 0.964286 "]
			} else {
			    set l [add_list $l "1.000000 0.000000 "]
			}
		    }
		} else {
		    if {$ATT83 < 0.143816} {
			if {$ATT73 < 0.977359} {
			    if {$ATT70 < 65.646851} {
				if {$ATT46 < 0.001790} {
				    if {$ATT98 < 2.675000} {
					set l [add_list $l "0.039216 0.960784 "]
				    } else {
					if {$ATT88 < 1.019732} {
					    set l [add_list $l "0.100000 0.900000 "]
					} else {
					    set l [add_list $l "0.777778 0.222222 "]
					}
				    }
				} else {
				    if {$ATT88 < 1.156669} {
					if {$ATT46 < 0.009330} {
					    if {$ATT7 < 805.062134} {
						if {$ATT74 < 0.036651} {
						    set l [add_list $l "1.000000 0.000000 "]
						} else {
						    if {$ATT96 < 0.022569} {
							set l [add_list $l "1.000000 0.000000 "]
						    } else {
							set l [add_list $l "0.250000 0.750000 "]
						    }
						}
					    } else {
						set l [add_list $l "0.173913 0.826087 "]
					    }
					} else {
					    set l [add_list $l "0.000000 1.000000 "]
					}
				    } else {
					set l [add_list $l "1.000000 0.000000 "]
				    }
				}
			    } else {
				set l [add_list $l "0.000000 1.000000 "]
			    }
			} else {
			    set l [add_list $l "0.928571 0.071429 "]
			}
		    } else {
			if {$ATT70 < 0.498653} {
			    set l [add_list $l "0.953846 0.046154 "]
			} else {
			    if {$ATT98 < 0.975000} {
				if {$ATT14 < 0.008538} {
				    if {$ATT27 < 1.838835} {
					set l [add_list $l "0.118644 0.881356 "]
				    } else {
					set l [add_list $l "1.000000 0.000000 "]
				    }
				} else {
				    if {$ATT3 < 2.650415} {
					if {$ATT4 < 2.396330} {
					    if {$ATT49 < 1.020375} {
						set l [add_list $l "0.923077 0.076923 "]
					    } else {
						if {$ATT46 < 0.131142} {
						    set l [add_list $l "0.000000 1.000000 "]
						} else {
						    set l [add_list $l "0.636364 0.363636 "]
						}
					    }
					} else {
					    set l [add_list $l "1.000000 0.000000 "]
					}
				    } else {
					if {$ATT81 < 0.870925} {
					    set l [add_list $l "1.000000 0.000000 "]
					} else {
					    set l [add_list $l "0.169811 0.830189 "]
					}
				    }
				}
			    } else {
				if {$ATT67 < 0.997835} {
				    set l [add_list $l "0.923077 0.076923 "]
				} else {
				    if {$ATT68 < 1.039778} {
					if {$ATT12 < 0.118603} {
					    set l [add_list $l "0.147059 0.852941 "]
					} else {
					    if {$ATT8 < 0.998205} {
						if {$ATT49 < 1.261641} {
						    if {$ATT49 < 0.934841} {
							set l [add_list $l "0.000000 1.000000 "]
						    } else {
							if {$ATT73 < 1.037354} {
							    if {$ATT46 < 0.015965} {
								set l [add_list $l "0.000000 1.000000 "]
							    } else {
								set l [add_list $l "0.917808 0.082192 "]
							    }
							} else {
							    set l [add_list $l "0.000000 1.000000 "]
							}
						    }
						} else {
						    if {$ATT98 < 1.816666} {
							set l [add_list $l "0.000000 1.000000 "]
						    } else {
							if {$ATT3 < 5.187388} {
							    if {$ATT5 < 2.023788} {
								set l [add_list $l "0.857143 0.142857 "]
							    } else {
								set l [add_list $l "0.058824 0.941176 "]
							    }
							} else {
							    set l [add_list $l "0.846154 0.153846 "]
							}
						    }
						}
					    } else {
						set l [add_list $l "0.218182 0.781818 "]
					    }
					}
				    } else {
					if {$ATT99 < 15.500000} {
					    if {$ATT49 < 1.026800} {
						if {$ATT46 < 0.089583} {
						    if {$ATT27 < 0.551159} {
							if {$ATT88 < 1.269310} {
							    if {$ATT28 < 0.001885} {
								set l [add_list $l "0.076923 0.923077 "]
							    } else {
								if {$ATT48 < 0.498637} {
								    if {$ATT84 < 1.042027} {
									set l [add_list $l "0.000000 1.000000 "]
								    } else {
									if {$ATT46 < 0.086384} {
									    if {$ATT46 < 0.071424} {
										if {$ATT67 < 1.046414} {
										    set l [add_list $l "0.000000 1.000000 "]
										} else {
										    if {$ATT92 < 1.095402} {
											set l [add_list $l "0.833333 0.166667 "]
										    } else {
											if {$ATT91 < 0.003171} {
											    set l [add_list $l "0.833333 0.166667 "]
											} else {
											    if {$ATT45 < 0.038479} {
												set l [add_list $l "0.000000 1.000000 "]
											    } else {
												if {$ATT14 < 0.005809} {
												    set l [add_list $l "1.000000 0.000000 "]
												} else {
												    if {$ATT7 < 973.420654} {
													if {$ATT50 < 0.547596} {
													    set l [add_list $l "0.285714 0.714286 "]
													} else {
													    if {$ATT99 < 7.500000} {
														set l [add_list $l "0.200000 0.800000 "]
													    } else {
														set l [add_list $l "0.928571 0.071429 "]
													    }
													}
												    } else {
													set l [add_list $l "0.000000 1.000000 "]
												    }
												}
											    }
											}
										    }
										}
									    } else {
										set l [add_list $l "0.947368 0.052632 "]
									    }
									} else {
									    set l [add_list $l "0.000000 1.000000 "]
									}
								    }
								} else {
								    set l [add_list $l "0.842105 0.157895 "]
								}
							    }
							} else {
							    set l [add_list $l "1.000000 0.000000 "]
							}
						    } else {
							if {$ATT49 < 0.999650} {
							    if {$ATT7 < 2017.314941} {
								if {$ATT49 < 0.968920} {
								    set l [add_list $l "0.833333 0.166667 "]
								} else {
								    set l [add_list $l "0.000000 1.000000 "]
								}
							    } else {
								set l [add_list $l "0.157895 0.842105 "]
							    }
							} else {
							    if {$ATT73 < 0.924103} {
								if {$ATT45 < 0.026696} {
								    set l [add_list $l "0.000000 1.000000 "]
								} else {
								    set l [add_list $l "0.777778 0.222222 "]
								}
							    } else {
								set l [add_list $l "0.951923 0.048077 "]
							    }
							}
						    }
						} else {
						    if {$ATT89 < 1.516253} {
							if {$ATT6 < 1.691550} {
							    set l [add_list $l "0.938679 0.061321 "]
							} else {
							    set l [add_list $l "0.200000 0.800000 "]
							}
						    } else {
							set l [add_list $l "0.000000 1.000000 "]
						    }
						}
					    } else {
						if {$ATT45 < 0.089942} {
						    if {$ATT73 < 0.620600} {
							set l [add_list $l "1.000000 0.000000 "]
						    } else {
							if {$ATT92 < 1.044796} {
							    set l [add_list $l "0.733333 0.266667 "]
							} else {
							    set l [add_list $l "0.212766 0.787234 "]
							}
						    }
						} else {
						    if {$ATT68 < 1.095134} {
							if {$ATT12 < 0.082706} {
							    set l [add_list $l "0.095238 0.904762 "]
							} else {
							    if {$ATT11 < 1.383736} {
								if {$ATT9 < 0.073702} {
								    set l [add_list $l "1.000000 0.000000 "]
								} else {
								    if {$ATT48 < 0.121323} {
									set l [add_list $l "1.000000 0.000000 "]
								    } else {
									if {$ATT70 < 1.288117} {
									    if {$ATT7 < 0.134998} {
										set l [add_list $l "0.000000 1.000000 "]
									    } else {
										if {$ATT11 < 1.273116} {
										    if {$ATT80 < 0.928506} {
											set l [add_list $l "1.000000 0.000000 "]
										    } else {
											if {$ATT45 < 0.112787} {
											    set l [add_list $l "0.083333 0.916667 "]
											} else {
											    if {$ATT45 < 0.128014} {
												set l [add_list $l "0.857143 0.142857 "]
											    } else {
												if {$ATT28 < 0.213131} {
												    set l [add_list $l "0.000000 1.000000 "]
												} else {
												    if {$ATT92 < 1.037764} {
													set l [add_list $l "1.000000 0.000000 "]
												    } else {
													if {$ATT96 < 0.376648} {
													    if {$ATT91 < 0.987208} {
														if {$ATT93 < 1.012350} {
														    if {$ATT96 < 0.175211} {
															if {$ATT7 < 0.637181} {
															    set l [add_list $l "1.000000 0.000000 "]
															} else {
															    if {$ATT5 < 2.974995} {
																if {$ATT11 < 0.407434} {
																    set l [add_list $l "0.800000 0.200000 "]
																} else {
																    set l [add_list $l "0.000000 1.000000 "]
																}
															    } else {
																set l [add_list $l "0.000000 1.000000 "]
															    }
															}
														    } else {
															set l [add_list $l "1.000000 0.000000 "]
														    }
														} else {
														    set l [add_list $l "0.111111 0.888889 "]
														}
													    } else {
														set l [add_list $l "1.000000 0.000000 "]
													    }
													} else {
													    set l [add_list $l "0.000000 1.000000 "]
													}
												    }
												}
											    }
											}
										    }
										} else {
										    set l [add_list $l "0.000000 1.000000 "]
										}
									    }
									} else {
									    set l [add_list $l "0.000000 1.000000 "]
									}
								    }
								}
							    } else {
								set l [add_list $l "0.789474 0.210526 "]
							    }
							}
						    } else {
							if {$ATT73 < 0.728302} {
							    if {$ATT93 < 1.217489} {
								if {$ATT10 < 0.496578} {
								    if {$ATT7 < 197.071060} {
									set l [add_list $l "1.000000 0.000000 "]
								    } else {
									if {$ATT99 < 5.500000} {
									    set l [add_list $l "1.000000 0.000000 "]
									} else {
									    if {$ATT81 < 1.174501} {
										if {$ATT9 < 1.383420} {
										    set l [add_list $l "0.100000 0.900000 "]
										} else {
										    set l [add_list $l "0.777778 0.222222 "]
										}
									    } else {
										set l [add_list $l "0.000000 1.000000 "]
									    }
									}
								    }
								} else {
								    set l [add_list $l "0.000000 1.000000 "]
								}
							    } else {
								set l [add_list $l "1.000000 0.000000 "]
							    }
							} else {
							    if {$ATT98 < 1.071429} {
								set l [add_list $l "0.000000 1.000000 "]
							    } else {
								if {$ATT13 < 0.125179} {
								    set l [add_list $l "0.796813 0.203187 "]
								} else {
								    if {$ATT91 < 0.942600} {
									if {$ATT84 < 1.065336} {
									    set l [add_list $l "0.000000 1.000000 "]
									} else {
									    if {$ATT12 < 0.126899} {
										if {$ATT49 < 2.000162} {
										    set l [add_list $l "0.111111 0.888889 "]
										} else {
										    set l [add_list $l "0.833333 0.166667 "]
										}
									    } else {
										set l [add_list $l "0.933333 0.066667 "]
									    }
									}
								    } else {
									set l [add_list $l "0.000000 1.000000 "]
								    }
								}
							    }
							}
						    }
						}
					    }
					} else {
					    if {$ATT2 < 6.613126} {
						if {$ATT67 < 1.043959} {
						    set l [add_list $l "1.000000 0.000000 "]
						} else {
						    if {$ATT73 < 0.552758} {
							set l [add_list $l "0.000000 1.000000 "]
						    } else {
							if {$ATT9 < 0.424813} {
							    set l [add_list $l "0.894737 0.105263 "]
							} else {
							    if {$ATT7 < 5902.647949} {
								if {$ATT45 < 0.068228} {
								    set l [add_list $l "0.156863 0.843137 "]
								} else {
								    if {$ATT49 < 1.040055} {
									if {$ATT7 < 831.241577} {
									    set l [add_list $l "1.000000 0.000000 "]
									} else {
									    set l [add_list $l "0.200000 0.800000 "]
									}
								    } else {
									if {$ATT74 < 0.972103} {
									    if {$ATT68 < 1.110158} {
										if {$ATT88 < 1.028774} {
										    set l [add_list $l "1.000000 0.000000 "]
										} else {
										    set l [add_list $l "0.166667 0.833333 "]
										}
									    } else {
										if {$ATT77 < 0.871747} {
										    if {$ATT96 < 0.080320} {
											set l [add_list $l "0.125000 0.875000 "]
										    } else {
											set l [add_list $l "1.000000 0.000000 "]
										    }
										} else {
										    set l [add_list $l "1.000000 0.000000 "]
										}
									    }
									} else {
									    set l [add_list $l "0.000000 1.000000 "]
									}
								    }
								}
							    } else {
								set l [add_list $l "1.000000 0.000000 "]
							    }
							}
						    }
						}
					    } else {
						set l [add_list $l "0.000000 1.000000 "]
					    }
					}
				    }
				}
			    }
			}
		    }
		}
	    } else {
		if {$ATT99 < 29.500000} {
		    if {$ATT68 < 1.003397} {
			set l [add_list $l "0.000000 1.000000 "]
		    } else {
			if {$ATT92 < 1.031765} {
			    if {$ATT27 < 0.073652} {
				set l [add_list $l "0.000000 1.000000 "]
			    } else {
				if {$ATT88 < 0.965222} {
				    if {$ATT11 < 0.408432} {
					set l [add_list $l "0.000000 1.000000 "]
				    } else {
					set l [add_list $l "1.000000 0.000000 "]
				    }
				} else {
				    if {$ATT88 < 1.013422} {
					set l [add_list $l "0.891892 0.108108 "]
				    } else {
					if {$ATT88 < 1.046850} {
					    set l [add_list $l "0.000000 1.000000 "]
					} else {
					    set l [add_list $l "0.714286 0.285714 "]
					}
				    }
				}
			    }
			} else {
			    if {$ATT9 < 75.265335} {
				set l [add_list $l "0.162544 0.837456 "]
			    } else {
				set l [add_list $l "1.000000 0.000000 "]
			    }
			}
		    }
		} else {
		    if {$ATT98 < 7.600000} {
			if {$ATT11 < 0.034409} {
			    set l [add_list $l "1.000000 0.000000 "]
			} else {
			    set l [add_list $l "0.033403 0.966597 "]
			}
		    } else {
			set l [add_list $l "1.000000 0.000000 "]
		    }
		}
	    }
	}
    } else {
	if {$ATT46 < 0.078919} {
	    if {$ATT81 < 0.078632} {
		set l [add_list $l "1.000000 0.000000 "]
	    } else {
		if {$ATT14 < 0.014168} {
		    if {$ATT67 < 0.978254} {
			if {$ATT14 < 0.006301} {
			    set l [add_list $l "0.065217 0.934783 "]
			} else {
			    if {$ATT13 < 3.348387} {
				set l [add_list $l "1.000000 0.000000 "]
			    } else {
				set l [add_list $l "0.000000 1.000000 "]
			    }
			}
		    } else {
			if {$ATT9 < 21261.757812} {
			    if {$ATT49 < 0.500132} {
				if {$ATT45 < 0.037535} {
				    set l [add_list $l "0.000000 1.000000 "]
				} else {
				    set l [add_list $l "1.000000 0.000000 "]
				}
			    } else {
			
				set l [add_list $l "0.014080 0.985920 "]
			    }
			} else {
			    if {$ATT1 < 1.410886} {
				set l [add_list $l "1.000000 0.000000 "]
			    } else {
				set l [add_list $l "0.200000 0.800000 "]
			    }
			}
		    }
		} else {
		    if {$ATT68 < 1.021165} {
			set l [add_list $l "0.000000 1.000000 "]
		    } else {
			if {$ATT45 < 0.044740} {
			    set l [add_list $l "0.000000 1.000000 "]
			} else {
			    if {$ATT74 < 0.008561} {
				set l [add_list $l "0.000000 1.000000 "]
			    } else {
				if {$ATT13 < 3.386364} {
				    if {$ATT6 < 0.235696} {
					set l [add_list $l "0.000000 1.000000 "]
				    } else {
					if {$ATT98 < 0.833333} {
					    if {$ATT12 < 0.153015} {
						set l [add_list $l "0.000000 1.000000 "]
					    } else {
						if {$ATT45 < 0.060245} {
						    set l [add_list $l "0.000000 1.000000 "]
						} else {
						    set l [add_list $l "0.875000 0.125000 "]
						}
					    }
					} else {
					    if {$ATT9 < 0.517290} {
						set l [add_list $l "1.000000 0.000000 "]
					    } else {
						if {$ATT80 < 1.066228} {
						    if {$ATT83 < 0.771940} {
							set l [add_list $l "1.000000 0.000000 "]
						    } else {
							set l [add_list $l "0.166667 0.833333 "]
						    }
						} else {
						    if {$ATT98 < 5.000000} {
							set l [add_list $l "0.870968 0.129032 "]
						    } else {
							set l [add_list $l "0.000000 1.000000 "]
						    }
						}
					    }
					}
				    }
				} else {
				    set l [add_list $l "0.029412 0.970588 "]
				}
			    }
			}
		    }
		}
	    }
	} else {
	    if {$ATT91 < 0.903835} {
		if {$ATT98 < 0.354167} {
		    set l [add_list $l "0.000000 1.000000 "]
		} else {
		    if {$ATT70 < 1.256496} {
			set l [add_list $l "0.782609 0.217391 "]
		    } else {
			set l [add_list $l "0.000000 1.000000 "]
		    }
		}
	    } else {
		if {$ATT88 < 0.960478} {
		    set l [add_list $l "0.903226 0.096774 "]
		} else {
		    if {$ATT9 < 11080.009766} {
			if {$ATT96 < 0.029901} {
			    set l [add_list $l "0.000000 1.000000 "]
			} else {
			    if {$ATT12 < 0.114136} {
				set l [add_list $l "0.048780 0.951219 "]
			    } else {
				if {$ATT49 < 1.000286} {
				    if {$ATT27 < 0.127375} {
					set l [add_list $l "1.000000 0.000000 "]
				    } else {
					if {$ATT1 < 1.263428} {
					    if {$ATT99 < 4.000000} {
						set l [add_list $l "0.285714 0.714286 "]
					    } else {
						set l [add_list $l "1.000000 0.000000 "]
					    }
					} else {
					    if {$ATT81 < 1.028244} {
						set l [add_list $l "0.117647 0.882353 "]
					    } else {
						set l [add_list $l "0.857143 0.142857 "]
					    }
					}
				    }
				} else {
				    if {$ATT91 < 1.077183} {
					if {$ATT77 < 0.982436} {
					    if {$ATT98 < 0.279221} {
						set l [add_list $l "0.000000 1.000000 "]
					    } else {
						if {$ATT99 < 22.500000} {
						    if {$ATT46 < 0.113727} {
							if {$ATT8 < 0.012689} {
							    set l [add_list $l "0.714286 0.285714 "]
							} else {
							    set l [add_list $l "0.134228 0.865772 "]
							}
						    } else {
							if {$ATT89 < 1.139799} {
							    if {$ATT50 < 2.366297} {
								if {$ATT93 < 0.951806} {
								    set l [add_list $l "1.000000 0.000000 "]
								} else {
								    if {$ATT83 < 0.965944} {
									if {$ATT81 < 1.031437} {
									    if {$ATT5 < 3.237933} {
										if {$ATT14 < 0.021793} {
										    if {$ATT94 < 0.989698} {
											set l [add_list $l "0.000000 1.000000 "]
										    } else {
											if {$ATT46 < 0.253972} {
											    if {$ATT77 < 0.848732} {
												set l [add_list $l "1.000000 0.000000 "]
											    } else {
												if {$ATT49 < 1.502760} {
												    set l [add_list $l "0.857143 0.142857 "]
												} else {
												    set l [add_list $l "0.232558 0.767442 "]
												}
											    }
											} else {
											    set l [add_list $l "1.000000 0.000000 "]
											}
										    }
										} else {
										    set l [add_list $l "0.000000 1.000000 "]
										}
									    } else {
										set l [add_list $l "1.000000 0.000000 "]
									    }
									} else {
									    set l [add_list $l "0.900000 0.100000 "]
									}
								    } else {
									set l [add_list $l "0.000000 1.000000 "]
								    }
								}
							    } else {
								set l [add_list $l "0.000000 1.000000 "]
							    }
							} else {
							    set l [add_list $l "1.000000 0.000000 "]
							}
						    }
						} else {
						    set l [add_list $l "0.000000 1.000000 "]
						}
					    }
					} else {
					    set l [add_list $l "0.000000 1.000000 "]
					}
				    } else {
					set l [add_list $l "1.000000 0.000000 "]
				    }
				}
			    }
			}
		    } else {
			set l [add_list $l "1.000000 0.000000 "]
		    }
		}
	    }
	}
    }
}
if {[lindex $l 0]>$P}  {
  
 return A
} else {
    return C
}

}
