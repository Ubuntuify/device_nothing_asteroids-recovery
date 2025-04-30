#=============================================================================
# Copyright (c) 2020-2024 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2014-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

enable_tracing_events()
{
    # timer
    echo 1 > /sys/kernel/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/tracing/events/timer/timer_expire_exit/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_expire_exit/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_init/enable
    echo 1 > /sys/kernel/tracing/events/timer/hrtimer_start/enable

    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/tracing/events/irq/enable

    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/tracing/events/workqueue/enable
    echo 1 > /sys/kernel/tracing/events/workqueue/workqueue_execute_start/enable

    # schedular
    # echo 1 > /sys/kernel/tracing/events/sched/sched_cpu_hotplug/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/tracing/events/sched/sched_wakeup_new/enable

    # sound
    # echo 1 > /sys/kernel/tracing/events/asoc/snd_soc_reg_read/enable
    # echo 1 > /sys/kernel/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    # echo 1 > /sys/kernel/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    # echo 1 > /sys/kernel/tracing/events/msm_vidc/enable

    # clock
    echo 1 > /sys/kernel/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/tracing/events/power/clock_disable/enable
    echo 1 > /sys/kernel/tracing/events/power/cpu_frequency/enable

    # regulator
    echo 1 > /sys/kernel/tracing/events/regulator/enable

    # power
    # echo 1 > /sys/kernel/tracing/events/msm_low_power/enable

    # fastrpc
    echo 1 > /sys/kernel/tracing/events/fastrpc/enable

    #emmc
    echo 1 > /sys/kernel/tracing/events/mmc/mmc_request_start/enable
    echo 1 > /sys/kernel/tracing/events/mmc/mmc_request_done/enable

    #iommu
    echo 1 > /sys/kernel/debug/tracing/events/iommu/map/enable
    echo 1 > /sys/kernel/debug/tracing/events/iommu/map_sg/enable
    echo 1 > /sys/kernel/debug/tracing/events/iommu/unmap/enable

    echo 1 > /sys/kernel/tracing/tracing_on
}

# function to disable SF tracing on perf config
sf_tracing_disablement()
{
    # disable SF tracing if its perf config
    if [ "$debug_build" = false ]
    then
        setprop debug.sf.enable_transaction_tracing 0
    fi
}

# function to enable ftrace events
enable_ftrace_event_tracing()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    enable_tracing_events
}

gemnoc_dump()
{
    #; gem_noc_qns_mc0_poc_err
    echo 0x24104010 1  > $DCC_PATH/config
    echo 0x24104020 6 > $DCC_PATH/config
    #; gem_noc_qns_mc1_poc_err
    echo 0x24144010 1 > $DCC_PATH/config
    echo 0x24144020 6 > $DCC_PATH/config
    #; gem_noc_qns_cnoc_poc_err
    echo 0x24190010 1 > $DCC_PATH/config
    echo 0x24190020 6 > $DCC_PATH/config
    #; gem_noc_qns_pcie_poc_err
    echo 0x24190410 1 > $DCC_PATH/config
    echo 0x24190420 6 > $DCC_PATH/config

    #;gem_noc_fault_FaultInStatus0_Low
    echo 0x24191048 1 > $DCC_PATH/config
    #;gem_noc_qns_mc0_poc_dbg_Cfg_Low/High
    echo 0x24100808 2 > $DCC_PATH/config
    #;gem_noc_qns_mc1_poc_dbg_Cfg_Low/High
    echo 0x24140808 2 > $DCC_PATH/config

    #; gem_noc_Coherent_even_chain_debug
    echo 0x24101000 3 > $DCC_PATH/config
    echo 0x3 > $DCC_PATH/loop
    echo 0x24101010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24101018 1 > $DCC_PATH/config

    #; gem_noc_NonCoherent_even_chain_debug
    echo 0x24101080 1 > $DCC_PATH/config
    echo 0x24101084 2 > $DCC_PATH/config
    echo 0x5 > $DCC_PATH/loop
    echo 0x24101090 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
	echo 0x24101098 1 > $DCC_PATH/config

    #; gem_noc_Coherent_odd_chain_debug
    echo 0x24141000 1 > $DCC_PATH/config
    echo 0x24141004 2 > $DCC_PATH/config
    echo 0x24141010 2 > $DCC_PATH/config
    echo 0x24141010 2 > $DCC_PATH/config
    echo 0x24141018 1 > $DCC_PATH/config

    #; gem_noc_NonCoherent_odd_chain_debug
    echo 0x24141080 1 > $DCC_PATH/config
    echo 0x24141084 1 > $DCC_PATH/config
    echo 0x5 > $DCC_PATH/loop
    echo 0x24141090 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24141098 1 > $DCC_PATH/config

    #; gem_noc_Coherent_sys_chain_debug
    echo 0x24181000 1 > $DCC_PATH/config
    echo 0x24181004 2 > $DCC_PATH/config
    echo 0x3 > $DCC_PATH/loop
    echo 0x24181010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24181018 1 > $DCC_PATH/config

    #; NonCoherent_sys_chain
    echo 0x24181100 3 > $DCC_PATH/config
    echo 0xC > $DCC_PATH/loop
    echo 0x24181110 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24181118 1 > $DCC_PATH/config

    #; gemnoc QOS Gen
    echo 0x24131010 1  > $DCC_PATH/config
    echo 0x24133010 1  > $DCC_PATH/config
    echo 0x24135010 1  > $DCC_PATH/config
    echo 0x24137010 1  > $DCC_PATH/config
    echo 0x24138010 1  > $DCC_PATH/config
    echo 0x24171010 1  > $DCC_PATH/config
    echo 0x24173010 1  > $DCC_PATH/config
    echo 0x24175010 1  > $DCC_PATH/config
    echo 0x24177010 1  > $DCC_PATH/config
    echo 0x24178010 1  > $DCC_PATH/config
    echo 0x241E2010 1  > $DCC_PATH/config
    echo 0x241E5010 1  > $DCC_PATH/config
    echo 0x241F1010 1  > $DCC_PATH/config
    echo 0x241F3010 1  > $DCC_PATH/config
    echo 0x241F5010 1  > $DCC_PATH/config
    echo 0x241F7010 1  > $DCC_PATH/config
    echo 0x241F9010 1  > $DCC_PATH/config
    echo 0x241FB010 1  > $DCC_PATH/config
    echo 0x241FC010 1  > $DCC_PATH/config
    echo 0x241FD010 1  > $DCC_PATH/config
    echo 0x241FF010 1  > $DCC_PATH/config
}

#gemnoc backup context in dcc
gemnoc_dump_full_cxt()
{
    # gem_noc_qns_mc0_poc_dbg_DumpBrief_Low
    echo 0x24100810 1 > $DCC_PATH/config
    #gem_noc_qns_mc0_poc_dbg_DumpTmoStream read 256 times
    echo 0x40 > $DCC_PATH/loop
    echo 0x24100830 2 > $DCC_PATH/config
    echo 0x24100830 2 > $DCC_PATH/config
    echo 0x24100830 2 > $DCC_PATH/config
    echo 0x24100830 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24100838 1 > $DCC_PATH/config

    # gem_noc_qns_mc1_poc_dbg_DumpBrief_Low
    echo 0x24140810 1 > $DCC_PATH/config
    #gem_noc_qns_mc1_poc_dbg_DumpTmoStream read 256 times
    echo 0x40 > $DCC_PATH/loop
    echo 0x24140830 2 > $DCC_PATH/config
    echo 0x24140830 2 > $DCC_PATH/config
    echo 0x24140830 2 > $DCC_PATH/config
    echo 0x24140830 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24140838 1 > $DCC_PATH/config

    # gem_noc_qns_cnoc_poc_dbg_DumpBrief_Low
    echo 0x24180010 1 > $DCC_PATH/config
    #gem_noc_qns_cnoc_poc_dbg_DumpTmoStream read 64 times
    echo 0x10 > $DCC_PATH/loop
    echo 0x24180030 2 > $DCC_PATH/config
    echo 0x24180030 2 > $DCC_PATH/config
    echo 0x24180030 2 > $DCC_PATH/config
    echo 0x24180030 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24180038 1 > $DCC_PATH/config

    # gem_noc_qns_pcie_poc_dbg_DumpBrief_Low
    echo 0x24180410 1 > $DCC_PATH/config
    #gem_noc_qns_pcie_poc_dbg_DumpTmoStatus read 64 times
    echo 0x10 > $DCC_PATH/loop
    echo 0x24180430 2 > $DCC_PATH/config
    echo 0x24180430 2 > $DCC_PATH/config
    echo 0x24180430 2 > $DCC_PATH/config
    echo 0x24180430 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x24180438 1 > $DCC_PATH/config
}

config_dc_noc_dump()
{
    #; dc_noc_dch_erl
    echo 0x240E0000 3 > $DCC_PATH/config
    echo 0x240E0010 1  > $DCC_PATH/config
    echo 0x240E0018 1  > $DCC_PATH/config
    echo 0x240E0020 8 > $DCC_PATH/config
    echo 0x240E0240 1  > $DCC_PATH/config
    echo 0x240E0248 1  > $DCC_PATH/config

    #; dc_noc_ch_hm13_erl
    echo 0x247F0000 3 > $DCC_PATH/config
    echo 0x247F0010 1  > $DCC_PATH/config
    echo 0x247F0018 1  > $DCC_PATH/config
    echo 0x247F0020 8 > $DCC_PATH/config
    echo 0x247F0240 1  > $DCC_PATH/config
    echo 0x247F0248 1  > $DCC_PATH/config

    #; ch_hm13/DebugChain
    echo 0x247f2018 1 > $DCC_PATH/config
    echo 0x247f2008 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x247f2010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

lpass_noc_dump()
{
    echo 0x3C40008 1  > $DCC_PATH/config
    echo 0x3C40010 1  > $DCC_PATH/config
    echo 0x3C40018 1  > $DCC_PATH/config
    echo 0x3C40020 8 > $DCC_PATH/config
    echo 0x3C44010 1  > $DCC_PATH/config
    echo 0x3C45010 1  > $DCC_PATH/config
    echo 0x3C46010 1  > $DCC_PATH/config
    echo 0x3C4B040 1  > $DCC_PATH/config
    echo 0x3C4B048 1  > $DCC_PATH/config
    echo 0x3C50008 1  > $DCC_PATH/config
    echo 0x3C50010 1  > $DCC_PATH/config
    echo 0x3C50018 1  > $DCC_PATH/config
    echo 0x3C50020 8 > $DCC_PATH/config
    echo 0x3C54010 1  > $DCC_PATH/config
    echo 0x3C56040 1  > $DCC_PATH/config
    echo 0x3C56048 1  > $DCC_PATH/config

    #; lpass_ag_noc_agnoc_core_DebugChain
    echo 0x3C41008 1 > $DCC_PATH/config
    echo 0x3C41018 1 > $DCC_PATH/config
    echo 0x5  > $DCC_PATH/loop
    echo 0x3C41010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; lpass_ag_noc_aml_noc_DebugChain
    echo 0x3C51008 1 > $DCC_PATH/config
    echo 0x3C51018 1 > $DCC_PATH/config
    echo 0x2  > $DCC_PATH/loop
    echo 0x3C51010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

turing_nsp_noc_dump()
{
    #;TURING_nsp_noc_erl
    echo 0x320C0008 1  > $DCC_PATH/config
    echo 0x320C0010 1  > $DCC_PATH/config
    echo 0x320C0018 1  > $DCC_PATH/config
    echo 0x320C0020 8 > $DCC_PATH/config
    echo 0x320C0240 1  > $DCC_PATH/config
    echo 0x320C0248 1  > $DCC_PATH/config
    #;TURING_nsp_noc_qnm_qosgen
    echo 0x320CC010 1  > $DCC_PATH/config
    echo 0x320CD010 1  > $DCC_PATH/config
    echo 0x320CE010 1  > $DCC_PATH/config
    #;TURING_nsp_noc_debug
    echo 0x320C1008 1  > $DCC_PATH/config
    echo 0x320C1018 1  > $DCC_PATH/config
    echo 0x5  > $DCC_PATH/loop
    echo 0x320C1010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

mmss_noc_dump()
{
    #; mmss_noc_mnoc_sf_ErrorLogger_erl
    echo 0x01400008 1  > $DCC_PATH/config
    echo 0x01400010 1  > $DCC_PATH/config
    echo 0x01400018 1  > $DCC_PATH/config
    echo 0x01400020 8 > $DCC_PATH/config
    echo 0x01418010 > $DCC_PATH/config
    echo 0x0145be40 1 > $DCC_PATH/config
    echo 0x0145be48 1 > $DCC_PATH/config

    #;mmss_noc_qnm_sf_qosgen
    echo 0x142A010 1  > $DCC_PATH/config
    echo 0x142B010 1  > $DCC_PATH/config
    echo 0x142C010 1  > $DCC_PATH/config
    echo 0x1430010 1  > $DCC_PATH/config

    #; mmss_noc_DebugChain_sf_debug
    echo 0x0145b808 1 > $DCC_PATH/config
    echo 0x0145b818 1 > $DCC_PATH/config
    echo 0x6  > $DCC_PATH/loop
    echo 0x0145b810 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; mmss_noc_QTB500_sf_DebugChain_debug
    echo 0x1403008 1 > $DCC_PATH/config
    echo 0x1403018 1 > $DCC_PATH/config
    echo 0x7  > $DCC_PATH/loop
    echo 0x1403010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; mmss_noc_mnoc_hf_ErrorLogger_erl
    echo 0x01480008 1 > $DCC_PATH/config
    echo 0x01480010 1 > $DCC_PATH/config
    echo 0x01480018 1 > $DCC_PATH/config
    echo 0x01480020 8 > $DCC_PATH/config
    echo 0x01480248 1 > $DCC_PATH/config

    #;mmss_noc_qnm_hf_qosgen
    echo 0x14A8010 1  > $DCC_PATH/config
    echo 0x14A9010 1  > $DCC_PATH/config
    echo 0x14AD010 1  > $DCC_PATH/config

    #; mmss_noc_DebugChain_hf_debug
    echo 0x01482008 1 > $DCC_PATH/config
    echo 0x01482018 1 > $DCC_PATH/config
    echo 0x7  > $DCC_PATH/loop
    echo 0x01482010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; mmss_noc_QTB500_hf_DebugChain_debug
    echo 0x1483008 1 > $DCC_PATH/config
    echo 0x1483018 1 > $DCC_PATH/config
    echo 0x9  > $DCC_PATH/loop
    echo 0x1483010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

system_noc_dump()
{
    #; system_noc_erl
    echo 0x01680008 1 > $DCC_PATH/config
    echo 0x01680010 1 > $DCC_PATH/config
    echo 0x01680018 1 > $DCC_PATH/config
    echo 0x01680020 8 > $DCC_PATH/config
    echo 0x01681040 1 > $DCC_PATH/config
    echo 0x01681048 1 > $DCC_PATH/config

    #;system_noc qos gen registers
    echo 0x1690010 1 > $DCC_PATH/config
    echo 0x169A010 1 > $DCC_PATH/config
    echo 0x169B010 1 > $DCC_PATH/config
    echo 0x169C010 1 > $DCC_PATH/config
    echo 0x169D010 1 > $DCC_PATH/config
    echo 0x169E010 1 > $DCC_PATH/config
    echo 0x169F010 1 > $DCC_PATH/config

    #; system_noc/DebugChain
    echo 0x01682018 1 > $DCC_PATH/config
    echo 0x01682008 1 > $DCC_PATH/config
    echo 0x7  > $DCC_PATH/loop
    echo 0x01682010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

aggre_noc_dump()
{
    #; a1_noc_aggre_noc_erl
    echo 0x016E0000 3 > $DCC_PATH/config
    echo 0x016E0010 1  > $DCC_PATH/config
    echo 0x016E0018 1  > $DCC_PATH/config
    echo 0x016E0020 8 > $DCC_PATH/config
    echo 0x016E0240 1  > $DCC_PATH/config
    echo 0x016E0248 1  > $DCC_PATH/config

    #; agree_noc1 qosgen registers
    echo 0x16EC010 1  > $DCC_PATH/config
    echo 0x16EF210 1  > $DCC_PATH/config
    echo 0x16F0010 1  > $DCC_PATH/config

    #; aggre_noc_DebugChain_ANOC_NIU_debug
    echo 0x016e1088 1 > $DCC_PATH/config
    echo 0x016e1098 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x16e1090 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; a1_noc_aggre_noc_ANOC_QTB/DebugChain
    echo 0x016e1118 1 > $DCC_PATH/config
    echo 0x016e1108 1 > $DCC_PATH/config
    echo 0x6  > $DCC_PATH/loop
    echo 0x016e1110 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; a2_noc_aggre_noc_erl
    echo 0x01700000 3 > $DCC_PATH/config
    echo 0x01700010 1 > $DCC_PATH/config
    echo 0x01700018 1 > $DCC_PATH/config
    echo 0x01700020 8 > $DCC_PATH/config
    echo 0x01700240 1 > $DCC_PATH/config
    echo 0x01700248 1 > $DCC_PATH/config

    #;agree_noc2 qosgen registers
    echo 0x1712010 1  > $DCC_PATH/config
    echo 0x1713010 1  > $DCC_PATH/config
    echo 0x1714010 1  > $DCC_PATH/config
    echo 0x1715010 1  > $DCC_PATH/config
    echo 0x1716010 1  > $DCC_PATH/config
    echo 0x1717010 1  > $DCC_PATH/config
    echo 0x1718010 1  > $DCC_PATH/config
    echo 0x1719010 1  > $DCC_PATH/config
    echo 0x171A010 1  > $DCC_PATH/config

    #; a2_noc_aggre_noc_center/DebugChain
    echo 0x01701018 1 > $DCC_PATH/config
    echo 0x01701008 1 > $DCC_PATH/config
    echo 0x6  > $DCC_PATH/loop
    echo 0x01701010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; a2_noc_aggre_noc_west/DebugChain
    echo 0x01701288 1 > $DCC_PATH/config
    echo 0x01701298 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x01701290 2 > $DCC_PATH/config
    echo 0x1  > $DCC_PATH/loop

    #;agree_noc_pcie_errlog registers
    echo 0x16C0000 3 > $DCC_PATH/config
    echo 0x16C0010 1  > $DCC_PATH/config
    echo 0x16C0018 1  > $DCC_PATH/config
    echo 0x16C0020 8 > $DCC_PATH/config
    echo 0x16C0240 1  > $DCC_PATH/config
    echo 0x16C0248 1  > $DCC_PATH/config
    echo 0x16CB010 1  > $DCC_PATH/config
    echo 0x16CC010 1  > $DCC_PATH/config

    #;agree_noc_debugchain_pcie_debug
    echo 0x16c2008 1  > $DCC_PATH/config
    echo 0x16c2018 1  > $DCC_PATH/config
    echo 0x4  > $DCC_PATH/loop
    echo 0x016c2010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #;aggre_noc_DebugChain_QTB_PCIe
    echo 0x16C3008 1  > $DCC_PATH/config
    echo 0x16C3018 1  > $DCC_PATH/config
    echo 0x4  > $DCC_PATH/loop
    echo 0x016C3010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

apss_noc_dump()
{
    #;APSS_NOC_WRAPPERapss_noc_erl
    echo 0x17610008 1 > $DCC_PATH/config
    echo 0x17610010 1 > $DCC_PATH/config
    echo 0x17610020 8 > $DCC_PATH/config
    echo 0x17610240 1 > $DCC_PATH/config
    echo 0x17610248 1 > $DCC_PATH/config

    #;APSS_NOC_WRAPPERapss_noc_debug
    echo 0x17612018 1 > $DCC_PATH/config
    echo 0x17612008 1 > $DCC_PATH/config
    echo 0x6  > $DCC_PATH/loop
    echo 0x17612010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}


config_noc_dump()
{
    #; cnoc_cfg_erl
    echo 0x1600008 1  > $DCC_PATH/config
    echo 0x1600010 1  > $DCC_PATH/config
    echo 0x1600018 1  > $DCC_PATH/config
    echo 0x1600020 8 > $DCC_PATH/config
    echo 0x1600240 5 > $DCC_PATH/config
    echo 0x1600258 1  > $DCC_PATH/config

    #; cnoc_cfg_center/DebugChain
    echo 0x01602018 1 > $DCC_PATH/config
    echo 0x01602008 1 > $DCC_PATH/config
    echo 0x8  > $DCC_PATH/loop
    echo 0x01602010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_cfg_mmnoc_hf_DebugChain
    echo 0x01602108 1 > $DCC_PATH/config
    echo 0x01602118 1 > $DCC_PATH/config
    echo 0x2  > $DCC_PATH/loop
    echo 0x01602110 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_cfg_north_DebugChain_debug
    echo 0x01602188 1 > $DCC_PATH/config
    echo 0x01602198 1 > $DCC_PATH/config
    echo 0x2 > $DCC_PATH/loop
    echo 0x01602190 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_cfg_east_DebugChain_debug
    echo 0x01602288 1 > $DCC_PATH/config
    echo 0x01602298 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x01602290 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_cfg_west_DebugChain_debug
    echo 0x01602388 1 > $DCC_PATH/config
    echo 0x01602398 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x01602390 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_main_erl
    echo 0x1500008 1  > $DCC_PATH/config
    echo 0x1500010 1  > $DCC_PATH/config
    echo 0x1500018 1  > $DCC_PATH/config
    echo 0x1500020 8 > $DCC_PATH/config
    echo 0x1500240 1  > $DCC_PATH/config
    echo 0x1500248 1  > $DCC_PATH/config
    echo 0x1500440 1  > $DCC_PATH/config
    echo 0x1500448 1  > $DCC_PATH/config

    #; cnoc_main_center/DebugChain
    echo 0x01502018 1 > $DCC_PATH/config
    echo 0x01502008 1 > $DCC_PATH/config
    echo 0xb  > $DCC_PATH/loop
    echo 0x01502010 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop

    #; cnoc_main_north/DebugChain
    echo 0x01502098 1 > $DCC_PATH/config
    echo 0x01502088 1 > $DCC_PATH/config
    echo 0x3  > $DCC_PATH/loop
    echo 0x01502090 2 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
}

config_dcc_ddr()
{
    #DDR -DCC starts here.
    #DDRSS
    echo 0x174070 1  > $DCC_PATH/config
    echo 0x196100 1  > $DCC_PATH/config
    echo 0x24453400 2  > $DCC_PATH/config
    echo 0x24042010 1  > $DCC_PATH/config
    echo 0x24042040 1  > $DCC_PATH/config
    echo 0x2404205C 1  > $DCC_PATH/config
    echo 0x24055008 1  > $DCC_PATH/config
    echo 0x24055070 1  > $DCC_PATH/config
    echo 0x24055948 1  > $DCC_PATH/config
    echo 0x24057008 1  > $DCC_PATH/config
    echo 0x24057018 1  > $DCC_PATH/config
    echo 0x24057028 1  > $DCC_PATH/config
    echo 0x24057038 1  > $DCC_PATH/config
    echo 0x24080024 1  > $DCC_PATH/config
    echo 0x2408002C 1  > $DCC_PATH/config
    echo 0x24080034 1  > $DCC_PATH/config
    echo 0x2408003C 1  > $DCC_PATH/config
    echo 0x24080044 1  > $DCC_PATH/config
    echo 0x2408004C 1  > $DCC_PATH/config
    echo 0x24080058 1  > $DCC_PATH/config
    echo 0x240800C8 1  > $DCC_PATH/config
    echo 0x24080144 1  > $DCC_PATH/config
    echo 0x2408014C 1  > $DCC_PATH/config
    echo 0x24080174 1  > $DCC_PATH/config
    echo 0x2408017C 1  > $DCC_PATH/config
    echo 0x24080184 1  > $DCC_PATH/config
    echo 0x2408018C 1  > $DCC_PATH/config
    echo 0x24080194 1  > $DCC_PATH/config
    echo 0x2408019C 1  > $DCC_PATH/config
    echo 0x240801A4 1  > $DCC_PATH/config
    echo 0x240801AC 1  > $DCC_PATH/config
    echo 0x24091000 1  > $DCC_PATH/config
    echo 0x24092000 1  > $DCC_PATH/config
    echo 0x24093000 1  > $DCC_PATH/config
    echo 0x24093104 1  > $DCC_PATH/config
    echo 0x24094000 1  > $DCC_PATH/config
    echo 0x24094000 1  > $DCC_PATH/config
    echo 0x24094104 1  > $DCC_PATH/config
    echo 0x24094104 1  > $DCC_PATH/config
    echo 0x24095220 9 > $DCC_PATH/config
    echo 0x240A1008 1  > $DCC_PATH/config
    echo 0x240A80E4 1  > $DCC_PATH/config
    echo 0x240A80F8 1  > $DCC_PATH/config
    echo 0x240A8100 1  > $DCC_PATH/config
    echo 0x240A8110 1  > $DCC_PATH/config
    echo 0x240A8120 1  > $DCC_PATH/config
    echo 0x240A81C8 1  > $DCC_PATH/config
    echo 0x240A8234 1  > $DCC_PATH/config
    echo 0x240A82D4 1  > $DCC_PATH/config
    echo 0x240A8834 1  > $DCC_PATH/config
    echo 0x240A8840 1  > $DCC_PATH/config
    echo 0x240A8854 1  > $DCC_PATH/config
    echo 0x240A8860 1  > $DCC_PATH/config
    echo 0x240A8878 1  > $DCC_PATH/config
    echo 0x240A888C 1  > $DCC_PATH/config
    echo 0x240A9140 1  > $DCC_PATH/config
    echo 0x240A9140 1  > $DCC_PATH/config
    echo 0x240A9188 1  > $DCC_PATH/config
    echo 0x240A91B8 1  > $DCC_PATH/config
    echo 0x240AA034 1  > $DCC_PATH/config
    echo 0x240AA04C 1  > $DCC_PATH/config
    echo 0x240AA058 1  > $DCC_PATH/config
    echo 0x240AA064 1  > $DCC_PATH/config
    echo 0x240AA0D4 1  > $DCC_PATH/config
    echo 0x24401814 1  > $DCC_PATH/config
    echo 0x24403814 1  > $DCC_PATH/config
    echo 0x24405014 1  > $DCC_PATH/config
    echo 0x24405530 1  > $DCC_PATH/config
    echo 0x24406C04 1  > $DCC_PATH/config
    echo 0x24406D04 1  > $DCC_PATH/config
    echo 0x2440729C 1  > $DCC_PATH/config
    echo 0x244072A8 1  > $DCC_PATH/config
    echo 0x2440759C 1  > $DCC_PATH/config
    echo 0x244075A8 1  > $DCC_PATH/config
    echo 0x24443400 1  > $DCC_PATH/config
    echo 0x24443420 1  > $DCC_PATH/config
    echo 0x24443430 1  > $DCC_PATH/config
    echo 0x24443430 1  > $DCC_PATH/config
    echo 0x24443460 2 > $DCC_PATH/config
    echo 0x2444390C 1  > $DCC_PATH/config
    echo 0x24450304 1  > $DCC_PATH/config
    echo 0x24450400 1  > $DCC_PATH/config
    echo 0x24450410 4  > $DCC_PATH/config
    echo 0x24450430 1  > $DCC_PATH/config
    echo 0x24450438 2  > $DCC_PATH/config
    echo 0x24450440 1  > $DCC_PATH/config
    echo 0x24450448 1  > $DCC_PATH/config
    echo 0x244504A0 1  > $DCC_PATH/config
    echo 0x244504B0 1  > $DCC_PATH/config
    echo 0x244504D0 1  > $DCC_PATH/config
    echo 0x244504E0 1  > $DCC_PATH/config
    echo 0x24452400 1  > $DCC_PATH/config
    echo 0x24452410 1  > $DCC_PATH/config
    echo 0x24452418 1  > $DCC_PATH/config
    echo 0x24452420 1  > $DCC_PATH/config
    echo 0x24452450 1  > $DCC_PATH/config
    echo 0x24455110 1  > $DCC_PATH/config
    echo 0x24455130 1  > $DCC_PATH/config
    echo 0x24455150 1  > $DCC_PATH/config
    echo 0x24455170 1  > $DCC_PATH/config
    echo 0x24455190 1  > $DCC_PATH/config
    echo 0x24455210 1  > $DCC_PATH/config
    echo 0x24455230 1  > $DCC_PATH/config
    echo 0x244553B0 1  > $DCC_PATH/config
    echo 0x24455C00 1  > $DCC_PATH/config
    echo 0x24455C28 1  > $DCC_PATH/config
    echo 0x24455C4C 1  > $DCC_PATH/config
    echo 0x24455C70 1  > $DCC_PATH/config
    echo 0x24455C90 2 > $DCC_PATH/config
    echo 0x24456428 3 > $DCC_PATH/config
    echo 0x24459100  1  > $DCC_PATH/config
    echo 0x24459110  1  > $DCC_PATH/config
    echo 0x24459120 1  > $DCC_PATH/config
    echo 0x244504B8 1  > $DCC_PATH/config
    echo 0x24480610 1  > $DCC_PATH/config
    echo 0x24480624 1  > $DCC_PATH/config
    echo 0x24480640 1  > $DCC_PATH/config
    echo 0x24480650 1  > $DCC_PATH/config
    echo 0x24480670 1  > $DCC_PATH/config
    echo 0x24480680 1  > $DCC_PATH/config
    echo 0x24501814 1  > $DCC_PATH/config
    echo 0x24503814 1  > $DCC_PATH/config
    echo 0x24505014 1  > $DCC_PATH/config
    echo 0x24505758 1  > $DCC_PATH/config
    echo 0x24506C04 1  > $DCC_PATH/config
    echo 0x24506D04 1  > $DCC_PATH/config
    echo 0x2450729C 1  > $DCC_PATH/config
    echo 0x245072A8 1  > $DCC_PATH/config
    echo 0x2450759C 1  > $DCC_PATH/config
    echo 0x245075A8 1  > $DCC_PATH/config
    echo 0x24543400 1  > $DCC_PATH/config
    echo 0x24543420 1  > $DCC_PATH/config
    echo 0x24543430 1  > $DCC_PATH/config
    echo 0x24543430 1  > $DCC_PATH/config
    echo 0x24543460 2 > $DCC_PATH/config
    echo 0x2454390C 1  > $DCC_PATH/config
    echo 0x24550304 1  > $DCC_PATH/config
    echo 0x24550400 1  > $DCC_PATH/config
    echo 0x24550410 4  > $DCC_PATH/config
    echo 0x24550430 1  > $DCC_PATH/config
    echo 0x24550438 2  > $DCC_PATH/config
    echo 0x24550440 1  > $DCC_PATH/config
    echo 0x24550448 1  > $DCC_PATH/config
    echo 0x245504A0 1  > $DCC_PATH/config
    echo 0x245504B0 1  > $DCC_PATH/config
    echo 0x245504D0 1  > $DCC_PATH/config
    echo 0x245504E0 1  > $DCC_PATH/config
    echo 0x24552400 1  > $DCC_PATH/config
    echo 0x24552410 1  > $DCC_PATH/config
    echo 0x24552418 1  > $DCC_PATH/config
    echo 0x24552420 1  > $DCC_PATH/config
    echo 0x24552450 1  > $DCC_PATH/config
    echo 0x24555110 1  > $DCC_PATH/config
    echo 0x24555130 1  > $DCC_PATH/config
    echo 0x24555150 1  > $DCC_PATH/config
    echo 0x24555170 1  > $DCC_PATH/config
    echo 0x24555190 1  > $DCC_PATH/config
    echo 0x24555210 1  > $DCC_PATH/config
    echo 0x24555230 1  > $DCC_PATH/config
    echo 0x245553B0 1  > $DCC_PATH/config
    echo 0x24555C00 1  > $DCC_PATH/config
    echo 0x24555C28 1  > $DCC_PATH/config
    echo 0x24555C4C 1  > $DCC_PATH/config
    echo 0x24555C70 1  > $DCC_PATH/config
    echo 0x24555C90 2 > $DCC_PATH/config
    echo 0x24556428 3 > $DCC_PATH/config
    echo 0x24559100 1  > $DCC_PATH/config
    echo 0x24559110 1  > $DCC_PATH/config
    echo 0x24559120 1  > $DCC_PATH/config
    echo 0x24580640 1  > $DCC_PATH/config
    echo 0x24580650 1  > $DCC_PATH/config
    echo 0x24580670 1  > $DCC_PATH/config
    echo 0x24580680 1  > $DCC_PATH/config
    echo 0x245504B8 1  > $DCC_PATH/config

    echo 0x24443400 7 > $DCC_PATH/config
    echo 0x24443420 2 > $DCC_PATH/config
    echo 0x24443430 5 > $DCC_PATH/config
    echo 0x24443460 6 > $DCC_PATH/config
    echo 0x2444390c  > $DCC_PATH/config
    echo 0x24443920  > $DCC_PATH/config
    echo 0x24443930 2 > $DCC_PATH/config
    echo 0x24443940  > $DCC_PATH/config
    echo 0x24444024 8 > $DCC_PATH/config
    echo 0x24444050 6 > $DCC_PATH/config
    echo 0x24444070  > $DCC_PATH/config
    echo 0x24444090 4 > $DCC_PATH/config
    echo 0x244440bc  > $DCC_PATH/config
    echo 0x24450108  > $DCC_PATH/config
    echo 0x24450208  > $DCC_PATH/config
    echo 0x24450304  > $DCC_PATH/config
    echo 0x244503c4  > $DCC_PATH/config
    echo 0x24450400 2 > $DCC_PATH/config
    echo 0x24450410 7 > $DCC_PATH/config
    echo 0x24450430 5 > $DCC_PATH/config
    echo 0x24450448  > $DCC_PATH/config
    echo 0x244504a0  > $DCC_PATH/config
    echo 0x244504b0 4 > $DCC_PATH/config
    echo 0x244504d0 3 > $DCC_PATH/config
    echo 0x244504e0  > $DCC_PATH/config
    echo 0x244504f0 2 > $DCC_PATH/config
    echo 0x24452400 2 > $DCC_PATH/config
    echo 0x24452410  > $DCC_PATH/config
    echo 0x24452418  > $DCC_PATH/config
    echo 0x24452420 22 > $DCC_PATH/config
    echo 0x24452480 5 > $DCC_PATH/config
    echo 0x24452600 9 > $DCC_PATH/config
    echo 0x24453154  > $DCC_PATH/config
    echo 0x24453400 10 > $DCC_PATH/config
    echo 0x24453448 3 > $DCC_PATH/config
    echo 0x24454358  > $DCC_PATH/config
    echo 0x2445439c  > $DCC_PATH/config
    echo 0x24454e20  > $DCC_PATH/config
    echo 0x24455080 2 > $DCC_PATH/config
    echo 0x2445510c 2 > $DCC_PATH/config
    echo 0x2445512c 2 > $DCC_PATH/config
    echo 0x2445514c 2 > $DCC_PATH/config
    echo 0x2445516c 2 > $DCC_PATH/config
    echo 0x2445518c 2 > $DCC_PATH/config
    echo 0x24455200  > $DCC_PATH/config
    echo 0x24455208 3 > $DCC_PATH/config
    echo 0x2445522c 2 > $DCC_PATH/config
    echo 0x2445523c  > $DCC_PATH/config
    echo 0x2445524c  > $DCC_PATH/config
    echo 0x2445534c  > $DCC_PATH/config
    echo 0x2445536c  > $DCC_PATH/config
    echo 0x244553b0 2 > $DCC_PATH/config
    echo 0x244556c0  > $DCC_PATH/config
    echo 0x244556e4 3 > $DCC_PATH/config
    echo 0x244556f4 3 > $DCC_PATH/config
    echo 0x24455704  > $DCC_PATH/config
    echo 0x2445570c  > $DCC_PATH/config
    echo 0x24455714  > $DCC_PATH/config
    echo 0x2445571c  > $DCC_PATH/config
    echo 0x24455724  > $DCC_PATH/config
    echo 0x2445572c  > $DCC_PATH/config
    echo 0x24455734  > $DCC_PATH/config
    echo 0x2445573c  > $DCC_PATH/config
    echo 0x24455744  > $DCC_PATH/config
    echo 0x2445574c  > $DCC_PATH/config
    echo 0x24455754  > $DCC_PATH/config
    echo 0x2445575c  > $DCC_PATH/config
    echo 0x24455764  > $DCC_PATH/config
    echo 0x2445576c  > $DCC_PATH/config
    echo 0x24455774  > $DCC_PATH/config
    echo 0x2445577c  > $DCC_PATH/config
    echo 0x24455784  > $DCC_PATH/config
    echo 0x2445578c  > $DCC_PATH/config
    echo 0x24455794  > $DCC_PATH/config
    echo 0x2445579c  > $DCC_PATH/config
    echo 0x244557a4  > $DCC_PATH/config
    echo 0x244557ac  > $DCC_PATH/config
    echo 0x244557b4  > $DCC_PATH/config
    echo 0x244557bc  > $DCC_PATH/config
    echo 0x244557c4  > $DCC_PATH/config
    echo 0x244557cc  > $DCC_PATH/config
    echo 0x244557d4  > $DCC_PATH/config
    echo 0x244557dc  > $DCC_PATH/config
    echo 0x244557e4  > $DCC_PATH/config
    echo 0x244557ec  > $DCC_PATH/config
    echo 0x244557f4  > $DCC_PATH/config
    echo 0x244557fc  > $DCC_PATH/config
    echo 0x2445580c  > $DCC_PATH/config
    echo 0x24455814  > $DCC_PATH/config
    echo 0x2445581c  > $DCC_PATH/config
    echo 0x24455824  > $DCC_PATH/config
    echo 0x2445582c  > $DCC_PATH/config
    echo 0x24455834  > $DCC_PATH/config
    echo 0x2445583c  > $DCC_PATH/config
    echo 0x24455844  > $DCC_PATH/config
    echo 0x2445584c  > $DCC_PATH/config
    echo 0x24455854  > $DCC_PATH/config
    echo 0x2445585c  > $DCC_PATH/config
    echo 0x24455864  > $DCC_PATH/config
    echo 0x2445586c  > $DCC_PATH/config
    echo 0x24455874  > $DCC_PATH/config
    echo 0x2445587c  > $DCC_PATH/config
    echo 0x24455884  > $DCC_PATH/config
    echo 0x2445588c  > $DCC_PATH/config
    echo 0x24455894  > $DCC_PATH/config
    echo 0x2445589c  > $DCC_PATH/config
    echo 0x244558a4  > $DCC_PATH/config
    echo 0x244558ac  > $DCC_PATH/config
    echo 0x244558b4  > $DCC_PATH/config
    echo 0x244558bc  > $DCC_PATH/config
    echo 0x244558c4  > $DCC_PATH/config
    echo 0x244558cc  > $DCC_PATH/config
    echo 0x244558d4  > $DCC_PATH/config
    echo 0x244558dc  > $DCC_PATH/config
    echo 0x244558e4  > $DCC_PATH/config
    echo 0x244558ec  > $DCC_PATH/config
    echo 0x244558f4  > $DCC_PATH/config
    echo 0x244558fc  > $DCC_PATH/config
    echo 0x24455904  > $DCC_PATH/config
    echo 0x24455914  > $DCC_PATH/config
    echo 0x2445591c  > $DCC_PATH/config
    echo 0x24455924  > $DCC_PATH/config
    echo 0x2445592c  > $DCC_PATH/config
    echo 0x24455934  > $DCC_PATH/config
    echo 0x2445593c  > $DCC_PATH/config
    echo 0x24455944  > $DCC_PATH/config
    echo 0x2445594c  > $DCC_PATH/config
    echo 0x24455954  > $DCC_PATH/config
    echo 0x2445595c  > $DCC_PATH/config
    echo 0x24455964  > $DCC_PATH/config
    echo 0x2445596c  > $DCC_PATH/config
    echo 0x24455974  > $DCC_PATH/config
    echo 0x2445597c  > $DCC_PATH/config
    echo 0x24455984  > $DCC_PATH/config
    echo 0x2445598c  > $DCC_PATH/config
    echo 0x24455a18  > $DCC_PATH/config
    echo 0x24455a80  > $DCC_PATH/config
    echo 0x24455a90  > $DCC_PATH/config
    echo 0x24455c00 8 > $DCC_PATH/config
    echo 0x24455c28 8 > $DCC_PATH/config
    echo 0x24455c4c 6 > $DCC_PATH/config
    echo 0x24455c70 18 > $DCC_PATH/config
    echo 0x24455cc0 15 > $DCC_PATH/config
    echo 0x24456050  > $DCC_PATH/config
    echo 0x24456314 2 > $DCC_PATH/config
    echo 0x24456428 5 > $DCC_PATH/config
    echo 0x24456500  > $DCC_PATH/config
    echo 0x24459100  > $DCC_PATH/config
    echo 0x24459110  > $DCC_PATH/config
    echo 0x24459120  > $DCC_PATH/config
    echo 0x244591A0  > $DCC_PATH/config
    echo 0x24459400  > $DCC_PATH/config
    echo 0x2445b054  > $DCC_PATH/config
    echo 0x2445b200  > $DCC_PATH/config
    echo 0x2445b220  > $DCC_PATH/config
    echo 0x2445b504  > $DCC_PATH/config
    echo 0x2445b510 6 > $DCC_PATH/config
    echo 0x2445b550  > $DCC_PATH/config
    echo 0x2445b900 4 > $DCC_PATH/config
    echo 0x2445d400  > $DCC_PATH/config
    echo 0x24543400 7 > $DCC_PATH/config
    echo 0x24543420 2 > $DCC_PATH/config
    echo 0x24543430 5 > $DCC_PATH/config
    echo 0x24543460 6 > $DCC_PATH/config
    echo 0x2454390c  > $DCC_PATH/config
    echo 0x24543920  > $DCC_PATH/config
    echo 0x24543930 2 > $DCC_PATH/config
    echo 0x24543940  > $DCC_PATH/config
    echo 0x24544024 8 > $DCC_PATH/config
    echo 0x24544050 6 > $DCC_PATH/config
    echo 0x24544070  > $DCC_PATH/config
    echo 0x24544090 4 > $DCC_PATH/config
    echo 0x245440bc  > $DCC_PATH/config
    echo 0x24550108  > $DCC_PATH/config
    echo 0x24550208  > $DCC_PATH/config
    echo 0x24550304  > $DCC_PATH/config
    echo 0x245503c4  > $DCC_PATH/config
    echo 0x24550400 2 > $DCC_PATH/config
    echo 0x24550410 7 > $DCC_PATH/config
    echo 0x24550430 5 > $DCC_PATH/config
    echo 0x24550448  > $DCC_PATH/config
    echo 0x245504a0  > $DCC_PATH/config
    echo 0x245504b0 4 > $DCC_PATH/config
    echo 0x245504d0 3 > $DCC_PATH/config
    echo 0x245504e0  > $DCC_PATH/config
    echo 0x245504f0 2 > $DCC_PATH/config
    echo 0x24552400 2 > $DCC_PATH/config
    echo 0x24552410  > $DCC_PATH/config
    echo 0x24552418  > $DCC_PATH/config
    echo 0x24552420 22 > $DCC_PATH/config
    echo 0x24552480 5 > $DCC_PATH/config
    echo 0x24552600 9 > $DCC_PATH/config
    echo 0x24553154  > $DCC_PATH/config
    echo 0x24553400 10 > $DCC_PATH/config
    echo 0x24553448 3 > $DCC_PATH/config
    echo 0x24554358  > $DCC_PATH/config
    echo 0x2455439c  > $DCC_PATH/config
    echo 0x24554e20  > $DCC_PATH/config
    echo 0x24555080 2 > $DCC_PATH/config
    echo 0x2455510c 2 > $DCC_PATH/config
    echo 0x2455512c 2 > $DCC_PATH/config
    echo 0x2455514c 2 > $DCC_PATH/config
    echo 0x2455516c 2 > $DCC_PATH/config
    echo 0x2455518c 2 > $DCC_PATH/config
    echo 0x24555200  > $DCC_PATH/config
    echo 0x24555208 3 > $DCC_PATH/config
    echo 0x2455522c 2 > $DCC_PATH/config
    echo 0x2455523c  > $DCC_PATH/config
    echo 0x2455524c  > $DCC_PATH/config
    echo 0x2455534c  > $DCC_PATH/config
    echo 0x2455536c  > $DCC_PATH/config
    echo 0x245553b0 2 > $DCC_PATH/config
    echo 0x245556c0  > $DCC_PATH/config
    echo 0x245556e4 3 > $DCC_PATH/config
    echo 0x245556f4 3 > $DCC_PATH/config
    echo 0x24555704  > $DCC_PATH/config
    echo 0x2455570c  > $DCC_PATH/config
    echo 0x24555714  > $DCC_PATH/config
    echo 0x2455571c  > $DCC_PATH/config
    echo 0x24555724  > $DCC_PATH/config
    echo 0x2455572c  > $DCC_PATH/config
    echo 0x24555734  > $DCC_PATH/config
    echo 0x2455573c  > $DCC_PATH/config
    echo 0x24555744  > $DCC_PATH/config
    echo 0x2455574c  > $DCC_PATH/config
    echo 0x24555754  > $DCC_PATH/config
    echo 0x2455575c  > $DCC_PATH/config
    echo 0x24555764  > $DCC_PATH/config
    echo 0x2455576c  > $DCC_PATH/config
    echo 0x24555774  > $DCC_PATH/config
    echo 0x2455577c  > $DCC_PATH/config
    echo 0x24555784  > $DCC_PATH/config
    echo 0x2455578c  > $DCC_PATH/config
    echo 0x24555794  > $DCC_PATH/config
    echo 0x2455579c  > $DCC_PATH/config
    echo 0x245557a4  > $DCC_PATH/config
    echo 0x245557ac  > $DCC_PATH/config
    echo 0x245557b4  > $DCC_PATH/config
    echo 0x245557bc  > $DCC_PATH/config
    echo 0x245557c4  > $DCC_PATH/config
    echo 0x245557cc  > $DCC_PATH/config
    echo 0x245557d4  > $DCC_PATH/config
    echo 0x245557dc  > $DCC_PATH/config
    echo 0x245557e4  > $DCC_PATH/config
    echo 0x245557ec  > $DCC_PATH/config
    echo 0x245557f4  > $DCC_PATH/config
    echo 0x245557fc  > $DCC_PATH/config
    echo 0x2455580c  > $DCC_PATH/config
    echo 0x24555814  > $DCC_PATH/config
    echo 0x2455581c  > $DCC_PATH/config
    echo 0x24555824  > $DCC_PATH/config
    echo 0x2455582c  > $DCC_PATH/config
    echo 0x24555834  > $DCC_PATH/config
    echo 0x2455583c  > $DCC_PATH/config
    echo 0x24555844  > $DCC_PATH/config
    echo 0x2455584c  > $DCC_PATH/config
    echo 0x24555854  > $DCC_PATH/config
    echo 0x2455585c  > $DCC_PATH/config
    echo 0x24555864  > $DCC_PATH/config
    echo 0x2455586c  > $DCC_PATH/config
    echo 0x24555874  > $DCC_PATH/config
    echo 0x2455587c  > $DCC_PATH/config
    echo 0x24555884  > $DCC_PATH/config
    echo 0x2455588c  > $DCC_PATH/config
    echo 0x24555894  > $DCC_PATH/config
    echo 0x2455589c  > $DCC_PATH/config
    echo 0x245558a4  > $DCC_PATH/config
    echo 0x245558ac  > $DCC_PATH/config
    echo 0x245558b4  > $DCC_PATH/config
    echo 0x245558bc  > $DCC_PATH/config
    echo 0x245558c4  > $DCC_PATH/config
    echo 0x245558cc  > $DCC_PATH/config
    echo 0x245558d4  > $DCC_PATH/config
    echo 0x245558dc  > $DCC_PATH/config
    echo 0x245558e4  > $DCC_PATH/config
    echo 0x245558ec  > $DCC_PATH/config
    echo 0x245558f4  > $DCC_PATH/config
    echo 0x245558fc  > $DCC_PATH/config
    echo 0x24555904  > $DCC_PATH/config
    echo 0x24555914  > $DCC_PATH/config
    echo 0x2455591c  > $DCC_PATH/config
    echo 0x24555924  > $DCC_PATH/config
    echo 0x2455592c  > $DCC_PATH/config
    echo 0x24555934  > $DCC_PATH/config
    echo 0x2455593c  > $DCC_PATH/config
    echo 0x24555944  > $DCC_PATH/config
    echo 0x2455594c  > $DCC_PATH/config
    echo 0x24555954  > $DCC_PATH/config
    echo 0x2455595c  > $DCC_PATH/config
    echo 0x24555964  > $DCC_PATH/config
    echo 0x2455596c  > $DCC_PATH/config
    echo 0x24555974  > $DCC_PATH/config
    echo 0x2455597c  > $DCC_PATH/config
    echo 0x24555984  > $DCC_PATH/config
    echo 0x2455598c  > $DCC_PATH/config
    echo 0x24555a18  > $DCC_PATH/config
    echo 0x24555a80  > $DCC_PATH/config
    echo 0x24555a90  > $DCC_PATH/config
    echo 0x24555c00 8 > $DCC_PATH/config
    echo 0x24555c28 8 > $DCC_PATH/config
    echo 0x24555c4c 6 > $DCC_PATH/config
    echo 0x24555c70 18 > $DCC_PATH/config
    echo 0x24555cc0 15 > $DCC_PATH/config
    echo 0x24556050  > $DCC_PATH/config
    echo 0x24556314 2 > $DCC_PATH/config
    echo 0x24556428 5 > $DCC_PATH/config
    echo 0x24556500  > $DCC_PATH/config
    echo 0x24559100  > $DCC_PATH/config
    echo 0x24559110  > $DCC_PATH/config
    echo 0x24559120  > $DCC_PATH/config
    echo 0x245591A0  > $DCC_PATH/config
    echo 0x24559400  > $DCC_PATH/config
    echo 0x2455b054  > $DCC_PATH/config
    echo 0x2455b200  > $DCC_PATH/config
    echo 0x2455b220  > $DCC_PATH/config
    echo 0x2455b504  > $DCC_PATH/config
    echo 0x2455b510 6 > $DCC_PATH/config
    echo 0x2455b550  > $DCC_PATH/config
    echo 0x2455b900 4 > $DCC_PATH/config
    echo 0x2455d400  > $DCC_PATH/config

    echo 0x24459100 1  > $DCC_PATH/config
    echo 0x24459110 1  > $DCC_PATH/config
    echo 0x24459120 1  > $DCC_PATH/config
    echo 0x24459170 1  > $DCC_PATH/config
    echo 0x24459180 2 > $DCC_PATH/config
    echo 0x244591A0 1  > $DCC_PATH/config
    echo 0x244591B0 1  > $DCC_PATH/config
    echo 0x244591C0 2 > $DCC_PATH/config
    echo 0x244591E0 1  > $DCC_PATH/config
    echo 0x24459400 1  > $DCC_PATH/config
    echo 0x24559100 1  > $DCC_PATH/config
    echo 0x24559110 1  > $DCC_PATH/config
    echo 0x24559120 1  > $DCC_PATH/config
    echo 0x24559170 1  > $DCC_PATH/config
    echo 0x24559180 2 > $DCC_PATH/config
    echo 0x245591A0 1  > $DCC_PATH/config
    echo 0x245591B0 1  > $DCC_PATH/config
    echo 0x245591C0 2 > $DCC_PATH/config
    echo 0x245591E0 1  > $DCC_PATH/config
    echo 0x24559400 1  > $DCC_PATH/config
}

config_dcc_rpmh()
{
    echo 0xB281024 1 > $DCC_PATH/config
    echo 0xBDE1034 1 > $DCC_PATH/config
    echo 0xB271020 2 > $DCC_PATH/config

    #RPMH_PDC_APSS
    echo 0xB201020 2 > $DCC_PATH/config
    echo 0xB211020 2 > $DCC_PATH/config
    echo 0xB221020 2 > $DCC_PATH/config
    echo 0xB231020 2 > $DCC_PATH/config
    echo 0xB204520 > $DCC_PATH/config
    echo 0xB200000 1 > $DCC_PATH/config
    echo 0xB210000 1 > $DCC_PATH/config
    echo 0xB220000 1 > $DCC_PATH/config
    echo 0xB230000 1 > $DCC_PATH/config

    echo 0x0B251020 2 > $DCC_PATH/config
    echo 0x0B251204 2 > $DCC_PATH/config
    echo 0x0B251218 2 > $DCC_PATH/config
    echo 0x0B25122C 2 > $DCC_PATH/config
    echo 0x0B251240 2 > $DCC_PATH/config
    echo 0x0B251254 2 > $DCC_PATH/config
    echo 0x0B5E2300  > $DCC_PATH/config
    echo 0x0B5E2310  > $DCC_PATH/config
    echo 0x0B600000  > $DCC_PATH/config
    echo 0x0B600010  > $DCC_PATH/config
    echo 0x0B600020  > $DCC_PATH/config
    echo 0x0B600030  > $DCC_PATH/config
    echo 0x0B600040  > $DCC_PATH/config
    echo 0x0B600050  > $DCC_PATH/config
    echo 0x0B600060  > $DCC_PATH/config
    echo 0x0B600070  > $DCC_PATH/config
    echo 0x0B600080  > $DCC_PATH/config
    echo 0x0B600090  > $DCC_PATH/config
    echo 0x0B6000A0  > $DCC_PATH/config
    echo 0x0B6000B0  > $DCC_PATH/config
    echo 0x0B6000C0  > $DCC_PATH/config
    echo 0x0B6000D0  > $DCC_PATH/config
    echo 0x0B6000E0  > $DCC_PATH/config
    echo 0x0B610000  > $DCC_PATH/config
    echo 0x0B610010  > $DCC_PATH/config
    echo 0x0B610020  > $DCC_PATH/config
    echo 0x0B610030  > $DCC_PATH/config
    echo 0x0B610040  > $DCC_PATH/config
    echo 0x0B610050  > $DCC_PATH/config
    echo 0x0B610060  > $DCC_PATH/config
    echo 0x0B610070  > $DCC_PATH/config
    echo 0x0B610080  > $DCC_PATH/config
    echo 0x0B610090  > $DCC_PATH/config
    echo 0x0B6100A0  > $DCC_PATH/config
    echo 0x0B6100B0  > $DCC_PATH/config
    echo 0x0B6100C0  > $DCC_PATH/config
    echo 0x0B6100D0  > $DCC_PATH/config
    echo 0x0B6100E0  > $DCC_PATH/config
    echo 0x0B620000  > $DCC_PATH/config
    echo 0x0B620010  > $DCC_PATH/config
    echo 0x0B620020  > $DCC_PATH/config
    echo 0x0B620030  > $DCC_PATH/config
    echo 0x0B620040  > $DCC_PATH/config
    echo 0x0B620050  > $DCC_PATH/config
    echo 0x0B620060  > $DCC_PATH/config
    echo 0x0B620070  > $DCC_PATH/config
    echo 0x0B620080  > $DCC_PATH/config
    echo 0x0B620090  > $DCC_PATH/config
    echo 0x0B6200A0  > $DCC_PATH/config
    echo 0x0B6200B0  > $DCC_PATH/config
    echo 0x0B6200C0  > $DCC_PATH/config
    echo 0x0B6200D0  > $DCC_PATH/config
    echo 0x0B6200E0  > $DCC_PATH/config
    echo 0x0B630000  > $DCC_PATH/config
    echo 0x0B630010  > $DCC_PATH/config
    echo 0x0B630020  > $DCC_PATH/config
    echo 0x0B630030  > $DCC_PATH/config
    echo 0x0B630040  > $DCC_PATH/config
    echo 0x0B630050  > $DCC_PATH/config
    echo 0x0B630060  > $DCC_PATH/config
    echo 0x0B630070  > $DCC_PATH/config
    echo 0x0B630080  > $DCC_PATH/config
    echo 0x0B630090  > $DCC_PATH/config
    echo 0x0B6300A0  > $DCC_PATH/config
    echo 0x0B6300B0  > $DCC_PATH/config
    echo 0x0B6300C0  > $DCC_PATH/config
    echo 0x0B6300D0  > $DCC_PATH/config
    echo 0x0B6300E0  > $DCC_PATH/config
    echo 0x0B640000  > $DCC_PATH/config
    echo 0x0B640010  > $DCC_PATH/config
    echo 0x0B640020  > $DCC_PATH/config
    echo 0x0B640030  > $DCC_PATH/config
    echo 0x0B640040  > $DCC_PATH/config
    echo 0x0B640050  > $DCC_PATH/config
    echo 0x0B640060  > $DCC_PATH/config
    echo 0x0B640070  > $DCC_PATH/config
    echo 0x0B640080  > $DCC_PATH/config
    echo 0x0B640090  > $DCC_PATH/config
    echo 0x0B6400A0  > $DCC_PATH/config
    echo 0x0B6400B0  > $DCC_PATH/config
    echo 0x0B6400C0  > $DCC_PATH/config
    echo 0x0B6400D0  > $DCC_PATH/config
    echo 0x0B6400E0  > $DCC_PATH/config
    echo 0x0B650000  > $DCC_PATH/config
    echo 0x0B650010  > $DCC_PATH/config
    echo 0x0B650020  > $DCC_PATH/config
    echo 0x0B650030  > $DCC_PATH/config
    echo 0x0B650040  > $DCC_PATH/config
    echo 0x0B650050  > $DCC_PATH/config
    echo 0x0B650060  > $DCC_PATH/config
    echo 0x0B650070  > $DCC_PATH/config
    echo 0x0B650080  > $DCC_PATH/config
    echo 0x0B650090  > $DCC_PATH/config
    echo 0x0B6500A0  > $DCC_PATH/config
    echo 0x0B6500B0  > $DCC_PATH/config
    echo 0x0B6500C0  > $DCC_PATH/config
    echo 0x0B6500D0  > $DCC_PATH/config
    echo 0x0B6500E0  > $DCC_PATH/config
    echo 0x0B660000  > $DCC_PATH/config
    echo 0x0B660010  > $DCC_PATH/config
    echo 0x0B660020  > $DCC_PATH/config
    echo 0x0B660030  > $DCC_PATH/config
    echo 0x0B660040  > $DCC_PATH/config
    echo 0x0B660050  > $DCC_PATH/config
    echo 0x0B660060  > $DCC_PATH/config
    echo 0x0B660070  > $DCC_PATH/config
    echo 0x0B660080  > $DCC_PATH/config
    echo 0x0B660090  > $DCC_PATH/config
    echo 0x0B6600A0  > $DCC_PATH/config
    echo 0x0B6600B0  > $DCC_PATH/config
    echo 0x0B6600C0  > $DCC_PATH/config
    echo 0x0B6600D0  > $DCC_PATH/config
    echo 0x0B6600E0  > $DCC_PATH/config
    echo 0x0B670000  > $DCC_PATH/config
    echo 0x0B670010  > $DCC_PATH/config
    echo 0x0B670020  > $DCC_PATH/config
    echo 0x0B670030  > $DCC_PATH/config
    echo 0x0B670040  > $DCC_PATH/config
    echo 0x0B670050  > $DCC_PATH/config
    echo 0x0B670060  > $DCC_PATH/config
    echo 0x0B670070  > $DCC_PATH/config
    echo 0x0B670080  > $DCC_PATH/config
    echo 0x0B670090  > $DCC_PATH/config
    echo 0x0B6700A0  > $DCC_PATH/config
    echo 0x0B6700B0  > $DCC_PATH/config
    echo 0x0B6700C0  > $DCC_PATH/config
    echo 0x0B6700D0  > $DCC_PATH/config
    echo 0x0B6700E0  > $DCC_PATH/config
    echo 0x0B680000  > $DCC_PATH/config
    echo 0x0B680010  > $DCC_PATH/config
    echo 0x0B680020  > $DCC_PATH/config
    echo 0x0B680030  > $DCC_PATH/config
    echo 0x0B680040  > $DCC_PATH/config
    echo 0x0B680050  > $DCC_PATH/config
    echo 0x0B680060  > $DCC_PATH/config
    echo 0x0B680070  > $DCC_PATH/config
    echo 0x0B680080  > $DCC_PATH/config
    echo 0x0B680090  > $DCC_PATH/config
    echo 0x0B6800A0  > $DCC_PATH/config
    echo 0x0B6800B0  > $DCC_PATH/config
    echo 0x0B6800C0  > $DCC_PATH/config
    echo 0x0B6800D0  > $DCC_PATH/config
    echo 0x0B6800E0  > $DCC_PATH/config
    echo 0x0B690000  > $DCC_PATH/config
    echo 0x0B690010  > $DCC_PATH/config
    echo 0x0B690020  > $DCC_PATH/config
    echo 0x0B690030  > $DCC_PATH/config
    echo 0x0B690040  > $DCC_PATH/config
    echo 0x0B690050  > $DCC_PATH/config
    echo 0x0B690060  > $DCC_PATH/config
    echo 0x0B690070  > $DCC_PATH/config
    echo 0x0B690080  > $DCC_PATH/config
    echo 0x0B690090  > $DCC_PATH/config
    echo 0x0B6900A0  > $DCC_PATH/config
    echo 0x0B6900B0  > $DCC_PATH/config
    echo 0x0B6900C0  > $DCC_PATH/config
    echo 0x0B6900D0  > $DCC_PATH/config
    echo 0x0B6900E0  > $DCC_PATH/config
    echo 0x0B6A0000  > $DCC_PATH/config
    echo 0x0B6A0010  > $DCC_PATH/config
    echo 0x0B6A0020  > $DCC_PATH/config
    echo 0x0B6A0030  > $DCC_PATH/config
    echo 0x0B6A0040  > $DCC_PATH/config
    echo 0x0B6A0050  > $DCC_PATH/config
    echo 0x0B6A0060  > $DCC_PATH/config
    echo 0x0B6A0070  > $DCC_PATH/config
    echo 0x0B6A0080  > $DCC_PATH/config
    echo 0x0B6A0090  > $DCC_PATH/config
    echo 0x0B6A00A0  > $DCC_PATH/config
    echo 0x0B6A00B0  > $DCC_PATH/config
    echo 0x0B6A00C0  > $DCC_PATH/config
    echo 0x0B6A00D0  > $DCC_PATH/config
    echo 0x0B6A00E0  > $DCC_PATH/config
    echo 0x0B6B0000  > $DCC_PATH/config
    echo 0x0B6B0010  > $DCC_PATH/config
    echo 0x0B6B0020  > $DCC_PATH/config
    echo 0x0B6B0030  > $DCC_PATH/config
    echo 0x0B6B0040  > $DCC_PATH/config
    echo 0x0B6B0050  > $DCC_PATH/config
    echo 0x0B6B0060  > $DCC_PATH/config
    echo 0x0B6B0070  > $DCC_PATH/config
    echo 0x0B6B0080  > $DCC_PATH/config
    echo 0x0B6B0090  > $DCC_PATH/config
    echo 0x0B6B00A0  > $DCC_PATH/config
    echo 0x0B6B00B0  > $DCC_PATH/config
    echo 0x0B6B00C0  > $DCC_PATH/config
    echo 0x0B6B00D0  > $DCC_PATH/config
    echo 0x0B6B00E0  > $DCC_PATH/config
    echo 0x0B6C0000  > $DCC_PATH/config
    echo 0x0B6C0010  > $DCC_PATH/config
    echo 0x0B6C0020  > $DCC_PATH/config
    echo 0x0B6C0030  > $DCC_PATH/config
    echo 0x0B6C0040  > $DCC_PATH/config
    echo 0x0B6C0050  > $DCC_PATH/config
    echo 0x0B6C0060  > $DCC_PATH/config
    echo 0x0B6C0070  > $DCC_PATH/config
    echo 0x0B6C0080  > $DCC_PATH/config
    echo 0x0B6C0090  > $DCC_PATH/config
    echo 0x0B6C00A0  > $DCC_PATH/config
    echo 0x0B6C00B0  > $DCC_PATH/config
    echo 0x0B6C00C0  > $DCC_PATH/config
    echo 0x0B6C00D0  > $DCC_PATH/config
    echo 0x0B6C00E0  > $DCC_PATH/config
    echo 0x0B6D0000  > $DCC_PATH/config
    echo 0x0B6D0010  > $DCC_PATH/config
    echo 0x0B6D0020  > $DCC_PATH/config
    echo 0x0B6D0030  > $DCC_PATH/config
    echo 0x0B6D0040  > $DCC_PATH/config
    echo 0x0B6D0050  > $DCC_PATH/config
    echo 0x0B6D0060  > $DCC_PATH/config
    echo 0x0B6D0070  > $DCC_PATH/config
    echo 0x0B6D0080  > $DCC_PATH/config
    echo 0x0B6D0090  > $DCC_PATH/config
    echo 0x0B6D00A0  > $DCC_PATH/config
    echo 0x0B6D00B0  > $DCC_PATH/config
    echo 0x0B6D00C0  > $DCC_PATH/config
    echo 0x0B6D00D0  > $DCC_PATH/config
    echo 0x0B6D00E0  > $DCC_PATH/config
    echo 0x0B6E0000  > $DCC_PATH/config
    echo 0x0B6E0010  > $DCC_PATH/config
    echo 0x0B6E0020  > $DCC_PATH/config
    echo 0x0B6E0030  > $DCC_PATH/config
    echo 0x0B6E0040  > $DCC_PATH/config
    echo 0x0B6E0050  > $DCC_PATH/config
    echo 0x0B6E0060  > $DCC_PATH/config
    echo 0x0B6E0070  > $DCC_PATH/config
    echo 0x0B6E0080  > $DCC_PATH/config
    echo 0x0B6E0090  > $DCC_PATH/config
    echo 0x0B6E00A0  > $DCC_PATH/config
    echo 0x0B6E00B0  > $DCC_PATH/config
    echo 0x0B6E00C0  > $DCC_PATH/config
    echo 0x0B6E00D0  > $DCC_PATH/config
    echo 0x0B6E00E0  > $DCC_PATH/config
    echo 0x0B6F0000  > $DCC_PATH/config
    echo 0x0B6F0010  > $DCC_PATH/config
    echo 0x0B6F0020  > $DCC_PATH/config
    echo 0x0B6F0030  > $DCC_PATH/config
    echo 0x0B6F0040  > $DCC_PATH/config
    echo 0x0B6F0050  > $DCC_PATH/config
    echo 0x0B6F0060  > $DCC_PATH/config
    echo 0x0B6F0070  > $DCC_PATH/config
    echo 0x0B6F0080  > $DCC_PATH/config
    echo 0x0B6F0090  > $DCC_PATH/config
    echo 0x0B6F00A0  > $DCC_PATH/config
    echo 0x0B6F00B0  > $DCC_PATH/config
    echo 0x0B6F00C0  > $DCC_PATH/config
    echo 0x0B6F00D0  > $DCC_PATH/config
    echo 0x0B6F00E0  > $DCC_PATH/config
    echo 0x0B700000  > $DCC_PATH/config
    echo 0x0B700010  > $DCC_PATH/config
    echo 0x0B700020  > $DCC_PATH/config
    echo 0x0B700030  > $DCC_PATH/config
    echo 0x0B700040  > $DCC_PATH/config
    echo 0x0B700050  > $DCC_PATH/config
    echo 0x0B700060  > $DCC_PATH/config
    echo 0x0B700070  > $DCC_PATH/config
    echo 0x0B700080  > $DCC_PATH/config
    echo 0x0B700090  > $DCC_PATH/config
    echo 0x0B7000A0  > $DCC_PATH/config
    echo 0x0B7000B0  > $DCC_PATH/config
    echo 0x0B7000C0  > $DCC_PATH/config
    echo 0x0B7000D0  > $DCC_PATH/config
    echo 0x0B7000E0  > $DCC_PATH/config
    echo 0x0B710000  > $DCC_PATH/config
    echo 0x0B710010  > $DCC_PATH/config
    echo 0x0B710020  > $DCC_PATH/config
    echo 0x0B710030  > $DCC_PATH/config
    echo 0x0B710040  > $DCC_PATH/config
    echo 0x0B710050  > $DCC_PATH/config
    echo 0x0B710060  > $DCC_PATH/config
    echo 0x0B710070  > $DCC_PATH/config
    echo 0x0B710080  > $DCC_PATH/config
    echo 0x0B710090  > $DCC_PATH/config
    echo 0x0B7100A0  > $DCC_PATH/config
    echo 0x0B7100B0  > $DCC_PATH/config
    echo 0x0B7100C0  > $DCC_PATH/config
    echo 0x0B7100D0  > $DCC_PATH/config
    echo 0x0B7100E0  > $DCC_PATH/config
    echo 0x0B720000  > $DCC_PATH/config
    echo 0x0B720010  > $DCC_PATH/config
    echo 0x0B720020  > $DCC_PATH/config
    echo 0x0B720030  > $DCC_PATH/config
    echo 0x0B720040  > $DCC_PATH/config
    echo 0x0B720050  > $DCC_PATH/config
    echo 0x0B720060  > $DCC_PATH/config
    echo 0x0B720070  > $DCC_PATH/config
    echo 0x0B720080  > $DCC_PATH/config
    echo 0x0B720090  > $DCC_PATH/config
    echo 0x0B7200A0  > $DCC_PATH/config
    echo 0x0B7200B0  > $DCC_PATH/config
    echo 0x0B7200C0  > $DCC_PATH/config
    echo 0x0B7200D0  > $DCC_PATH/config
    echo 0x0B7200E0  > $DCC_PATH/config
    echo 0x0B730000  > $DCC_PATH/config
    echo 0x0B730010  > $DCC_PATH/config
    echo 0x0B730020  > $DCC_PATH/config
    echo 0x0B730030  > $DCC_PATH/config
    echo 0x0B730040  > $DCC_PATH/config
    echo 0x0B730050  > $DCC_PATH/config
    echo 0x0B730060  > $DCC_PATH/config
    echo 0x0B730070  > $DCC_PATH/config
    echo 0x0B730080  > $DCC_PATH/config
    echo 0x0B730090  > $DCC_PATH/config
    echo 0x0B7300A0  > $DCC_PATH/config
    echo 0x0B7300B0  > $DCC_PATH/config
    echo 0x0B7300C0  > $DCC_PATH/config
    echo 0x0B7300D0  > $DCC_PATH/config
    echo 0x0B7300E0  > $DCC_PATH/config
    echo 0x0B740000  > $DCC_PATH/config
    echo 0x0B740010  > $DCC_PATH/config
    echo 0x0B740020  > $DCC_PATH/config
    echo 0x0B740030  > $DCC_PATH/config
    echo 0x0B740040  > $DCC_PATH/config
    echo 0x0B740050  > $DCC_PATH/config
    echo 0x0B740060  > $DCC_PATH/config
    echo 0x0B740070  > $DCC_PATH/config
    echo 0x0B740080  > $DCC_PATH/config
    echo 0x0B740090  > $DCC_PATH/config
    echo 0x0B7400A0  > $DCC_PATH/config
    echo 0x0B7400B0  > $DCC_PATH/config
    echo 0x0B7400C0  > $DCC_PATH/config
    echo 0x0B7400D0  > $DCC_PATH/config
    echo 0x0B7400E0  > $DCC_PATH/config
    echo 0x0B750000  > $DCC_PATH/config
    echo 0x0B750010  > $DCC_PATH/config
    echo 0x0B750020  > $DCC_PATH/config
    echo 0x0B750030  > $DCC_PATH/config
    echo 0x0B750040  > $DCC_PATH/config
    echo 0x0B750050  > $DCC_PATH/config
    echo 0x0B750060  > $DCC_PATH/config
    echo 0x0B750070  > $DCC_PATH/config
    echo 0x0B750080  > $DCC_PATH/config
    echo 0x0B750090  > $DCC_PATH/config
    echo 0x0B7500A0  > $DCC_PATH/config
    echo 0x0B7500B0  > $DCC_PATH/config
    echo 0x0B7500C0  > $DCC_PATH/config
    echo 0x0B7500D0  > $DCC_PATH/config
    echo 0x0B7500E0  > $DCC_PATH/config
    echo 0x0B760000  > $DCC_PATH/config
    echo 0x0B760010  > $DCC_PATH/config
    echo 0x0B760020  > $DCC_PATH/config
    echo 0x0B760030  > $DCC_PATH/config
    echo 0x0B760040  > $DCC_PATH/config
    echo 0x0B760050  > $DCC_PATH/config
    echo 0x0B760060  > $DCC_PATH/config
    echo 0x0B760070  > $DCC_PATH/config
    echo 0x0B760080  > $DCC_PATH/config
    echo 0x0B760090  > $DCC_PATH/config
    echo 0x0B7600A0  > $DCC_PATH/config
    echo 0x0B7600B0  > $DCC_PATH/config
    echo 0x0B7600C0  > $DCC_PATH/config
    echo 0x0B7600D0  > $DCC_PATH/config
    echo 0x0B7600E0  > $DCC_PATH/config
    echo 0x0B770000  > $DCC_PATH/config
    echo 0x0B770010  > $DCC_PATH/config
    echo 0x0B770020  > $DCC_PATH/config
    echo 0x0B770030  > $DCC_PATH/config
    echo 0x0B770040  > $DCC_PATH/config
    echo 0x0B770050  > $DCC_PATH/config
    echo 0x0B770060  > $DCC_PATH/config
    echo 0x0B770070  > $DCC_PATH/config
    echo 0x0B770080  > $DCC_PATH/config
    echo 0x0B770090  > $DCC_PATH/config
    echo 0x0B7700A0  > $DCC_PATH/config
    echo 0x0B7700B0  > $DCC_PATH/config
    echo 0x0B7700C0  > $DCC_PATH/config
    echo 0x0B7700D0  > $DCC_PATH/config
    echo 0x0B7700E0  > $DCC_PATH/config
    echo 0x0B780000  > $DCC_PATH/config
    echo 0x0B780010  > $DCC_PATH/config
    echo 0x0B780020  > $DCC_PATH/config
    echo 0x0B780030  > $DCC_PATH/config
    echo 0x0B780040  > $DCC_PATH/config
    echo 0x0B780050  > $DCC_PATH/config
    echo 0x0B780060  > $DCC_PATH/config
    echo 0x0B780070  > $DCC_PATH/config
    echo 0x0B780080  > $DCC_PATH/config
    echo 0x0B780090  > $DCC_PATH/config
    echo 0x0B7800A0  > $DCC_PATH/config
    echo 0x0B7800B0  > $DCC_PATH/config
    echo 0x0B7800C0  > $DCC_PATH/config
    echo 0x0B7800D0  > $DCC_PATH/config
    echo 0x0B7800E0  > $DCC_PATH/config
    echo 0x0B7F00C0 15 > $DCC_PATH/config
    echo 0x0B7F4500  > $DCC_PATH/config
    echo 0x0B7F4540  > $DCC_PATH/config
    echo 0x0B7F4580  > $DCC_PATH/config
    echo 0x0B7F45C0  > $DCC_PATH/config
    echo 0x0B7F4600  > $DCC_PATH/config
    echo 0x0B7F4640  > $DCC_PATH/config
    echo 0x0B7F4680  > $DCC_PATH/config
    echo 0x0B7F46C0  > $DCC_PATH/config
    echo 0x0B7F4700  > $DCC_PATH/config
    echo 0x0B7F4740  > $DCC_PATH/config
    echo 0x0B7F4780  > $DCC_PATH/config
    echo 0x0B7F47C0  > $DCC_PATH/config
    echo 0x0B7F4800  > $DCC_PATH/config
    echo 0x0B7F4840  > $DCC_PATH/config
    echo 0x0B7F4880  > $DCC_PATH/config
    echo 0x0BA00000 32 > $DCC_PATH/config
    echo 0x0BA10000 32 > $DCC_PATH/config
    echo 0x0BA20000 32 > $DCC_PATH/config
    echo 0x0BA30000 32 > $DCC_PATH/config
    echo 0x0BA40000 32 > $DCC_PATH/config
    echo 0x0BA50000 32 > $DCC_PATH/config
    echo 0x0BA60000 32 > $DCC_PATH/config
    echo 0x0BA70000 32 > $DCC_PATH/config
    echo 0x0BA80000 32 > $DCC_PATH/config
    echo 0x0BA90000 32 > $DCC_PATH/config
    echo 0x0BAA0000 32 > $DCC_PATH/config
    echo 0x0BAB0000 32 > $DCC_PATH/config
    echo 0x0BAC0000 32 > $DCC_PATH/config
    echo 0x0BAD0000 32 > $DCC_PATH/config
    echo 0x0BAE0000 32 > $DCC_PATH/config
    echo 0x0BAF0000 32 > $DCC_PATH/config
    echo 0x0BB00000 32 > $DCC_PATH/config
    echo 0x0BB10000 32 > $DCC_PATH/config
    echo 0x0BB20000 32 > $DCC_PATH/config
    echo 0x0BB30000 32 > $DCC_PATH/config
    echo 0x0BB40000 32 > $DCC_PATH/config
    echo 0x0BB50000 32 > $DCC_PATH/config
    echo 0x0BB60000 32 > $DCC_PATH/config
    echo 0x0BBF0800 13 > $DCC_PATH/config
    echo 0x0BBF0880 13 > $DCC_PATH/config
}

config_dcc_apss_rscc()
{
    #APSS_RSCC_RSC register
    echo 0x17A00010 1 > $DCC_PATH/config
    echo 0x17A10010 1 > $DCC_PATH/config
    echo 0x17A20010 1 > $DCC_PATH/config
    echo 0x17A30010 1 > $DCC_PATH/config
    echo 0x17A00030 1 > $DCC_PATH/config
    echo 0x17A10030 1 > $DCC_PATH/config
    echo 0x17A20030 1 > $DCC_PATH/config
    echo 0x17A30030 1 > $DCC_PATH/config
    echo 0x17A00038 1 > $DCC_PATH/config
    echo 0x17A10038 1 > $DCC_PATH/config
    echo 0x17A20038 1 > $DCC_PATH/config
    echo 0x17A30038 1 > $DCC_PATH/config
    echo 0x17A00040 1 > $DCC_PATH/config
    echo 0x17A10040 1 > $DCC_PATH/config
    echo 0x17A20040 1 > $DCC_PATH/config
    echo 0x17A30040 1 > $DCC_PATH/config
    echo 0x17A00048 1 > $DCC_PATH/config
    echo 0x17A00400 3 > $DCC_PATH/config
    echo 0x17A10400 3 > $DCC_PATH/config
    echo 0x17A20400 3 > $DCC_PATH/config
    echo 0x17A30400 3 > $DCC_PATH/config
    echo 0x17a10d3c 1 > $DCC_PATH/config
    echo 0x17a10d54 1 > $DCC_PATH/config
    echo 0x17a10d6c 1 > $DCC_PATH/config
    echo 0x17a10d84 1 > $DCC_PATH/config
    echo 0x17a10d9c 1 > $DCC_PATH/config
    echo 0x17a10db4 1 > $DCC_PATH/config
    echo 0x17a10dcc 1 > $DCC_PATH/config
    echo 0x17a10de4 1 > $DCC_PATH/config
    echo 0x17a10dfc 1 > $DCC_PATH/config
    echo 0x17a10e14 1 > $DCC_PATH/config
    echo 0x17a10e2c 1 > $DCC_PATH/config
    echo 0x17a10e44 1 > $DCC_PATH/config
    echo 0x17a10e5c 1 > $DCC_PATH/config
    echo 0x17a10e74 1 > $DCC_PATH/config
    echo 0x17a10e8c 1 > $DCC_PATH/config
    echo 0x17a10ea4 1 > $DCC_PATH/config
    echo 0x17a10fdc 1 > $DCC_PATH/config
    echo 0x17a10ff4 1 > $DCC_PATH/config
    echo 0x17a1100c 1 > $DCC_PATH/config
    echo 0x17a11024 1 > $DCC_PATH/config
    echo 0x17a1103c 1 > $DCC_PATH/config
    echo 0x17a11054 1 > $DCC_PATH/config
    echo 0x17a1106c 1 > $DCC_PATH/config
    echo 0x17a11084 1 > $DCC_PATH/config
    echo 0x17a1109c 1 > $DCC_PATH/config
    echo 0x17a110b4 1 > $DCC_PATH/config
    echo 0x17a110cc 1 > $DCC_PATH/config
    echo 0x17a110e4 1 > $DCC_PATH/config
    echo 0x17a110fc 1 > $DCC_PATH/config
    echo 0x17a11114 1 > $DCC_PATH/config
    echo 0x17a1112c 1 > $DCC_PATH/config
    echo 0x17a11144 1 > $DCC_PATH/config
    echo 0x17a1127c 1 > $DCC_PATH/config
    echo 0x17a11294 1 > $DCC_PATH/config
    echo 0x17a112ac 1 > $DCC_PATH/config
    echo 0x17a112c4 1 > $DCC_PATH/config
    echo 0x17a112dc 1 > $DCC_PATH/config
    echo 0x17a112f4 1 > $DCC_PATH/config
    echo 0x17a1130c 1 > $DCC_PATH/config
    echo 0x17a11324 1 > $DCC_PATH/config
    echo 0x17a1133c 1 > $DCC_PATH/config
    echo 0x17a11354 1 > $DCC_PATH/config
    echo 0x17a1136c 1 > $DCC_PATH/config
    echo 0x17a11384 1 > $DCC_PATH/config
    echo 0x17a1139c 1 > $DCC_PATH/config
    echo 0x17a113b4 1 > $DCC_PATH/config
    echo 0x17a113cc 1 > $DCC_PATH/config
    echo 0x17a113e4 1 > $DCC_PATH/config
    echo 0x17a1151c 1 > $DCC_PATH/config
    echo 0x17a11534 1 > $DCC_PATH/config
    echo 0x17a1154c 1 > $DCC_PATH/config
    echo 0x17a11564 1 > $DCC_PATH/config
    echo 0x17a1157c 1 > $DCC_PATH/config
    echo 0x17a11594 1 > $DCC_PATH/config
    echo 0x17a115ac 1 > $DCC_PATH/config
    echo 0x17a115c4 1 > $DCC_PATH/config
    echo 0x17a115dc 1 > $DCC_PATH/config
    echo 0x17a115f4 1 > $DCC_PATH/config
    echo 0x17a1160c 1 > $DCC_PATH/config
    echo 0x17a11624 1 > $DCC_PATH/config
    echo 0x17a1163c 1 > $DCC_PATH/config
    echo 0x17a11654 1 > $DCC_PATH/config
    echo 0x17a1166c 1 > $DCC_PATH/config
    echo 0x17a11684 1 > $DCC_PATH/config
}

config_dcc_misc()
{
    #WDOG register
    echo 0xC234004 5 > $DCC_PATH/config
    echo 0x5 > $DCC_PATH/loop
    echo 0x17410000 6 > $DCC_PATH/config
    echo 0x17411000 6 > $DCC_PATH/config
    echo 0x1 > $DCC_PATH/loop
    echo 0x150075DC 1 > $DCC_PATH/config
    echo 0x15002204 1 > $DCC_PATH/config
    echo 0x15002670 1 > $DCC_PATH/config
}

config_dcc_epss()
{
    #EPSSFAST_SEQ_MEM_r register
    echo 0x17D9001C 1 > $DCC_PATH/config
    echo 0x17D900DC 1 > $DCC_PATH/config
    echo 0x17D900E8 1 > $DCC_PATH/config
    echo 0x17D90320 1 > $DCC_PATH/config
    echo 0x17D9101C 1 > $DCC_PATH/config
    echo 0x17D910DC 1 > $DCC_PATH/config
    echo 0x17D910E8 1 > $DCC_PATH/config
    echo 0x17D91320 1 > $DCC_PATH/config
    echo 0x17D9201C 1 > $DCC_PATH/config
    echo 0x17D920DC 1 > $DCC_PATH/config
    echo 0x17D920E8 1 > $DCC_PATH/config
    echo 0x17D92320 1 > $DCC_PATH/config
    echo 0x17d90000 4 > $DCC_PATH/config
    echo 0x17d90014 2 > $DCC_PATH/config
    echo 0x17d90080 5 > $DCC_PATH/config
    echo 0x17d900b0 1 > $DCC_PATH/config
    echo 0x17d900b8 2 > $DCC_PATH/config
    echo 0x17d900d0 3 > $DCC_PATH/config
    echo 0x17d900e0 2 > $DCC_PATH/config
    echo 0x17d900ec 2 > $DCC_PATH/config
    echo 0x17d90100 1 > $DCC_PATH/config
    echo 0x17d90200 1 > $DCC_PATH/config
    echo 0x17d90304 4 > $DCC_PATH/config
    echo 0x17d903e0 2 > $DCC_PATH/config
    echo 0x17d90404 1 > $DCC_PATH/config
    echo 0x17d91000 4 > $DCC_PATH/config
    echo 0x17d91014 2 > $DCC_PATH/config
    echo 0x17d91080 8 > $DCC_PATH/config
    echo 0x17d910b0 1 > $DCC_PATH/config
    echo 0x17d910b8 2 > $DCC_PATH/config
    echo 0x17d910d0 3 > $DCC_PATH/config
    echo 0x17d910e0 2 > $DCC_PATH/config
    echo 0x17d910ec 2 > $DCC_PATH/config
    echo 0x17d91100 1 > $DCC_PATH/config
    echo 0x17d91200 1 > $DCC_PATH/config
    echo 0x17d91304 4 > $DCC_PATH/config
    echo 0x17d91324 3 > $DCC_PATH/config
    echo 0x17d913e0 5 > $DCC_PATH/config
    echo 0x17d91404 1 > $DCC_PATH/config
    echo 0x17d92000 4 > $DCC_PATH/config
    echo 0x17d92014 2 > $DCC_PATH/config
    echo 0x17d92080 7 > $DCC_PATH/config
    echo 0x17d920b0 1 > $DCC_PATH/config
    echo 0x17d920b8 2 > $DCC_PATH/config
    echo 0x17d920d0 3 > $DCC_PATH/config
    echo 0x17d920e0 2 > $DCC_PATH/config
    echo 0x17d920ec 2 > $DCC_PATH/config
    echo 0x17d92100 1 > $DCC_PATH/config
    echo 0x17d92200 1 > $DCC_PATH/config
    echo 0x17d92304 4 > $DCC_PATH/config
    echo 0x17d92324 2 > $DCC_PATH/config
    echo 0x17d923e0 4 > $DCC_PATH/config
    echo 0x17d92404 1 > $DCC_PATH/config
    echo 0x17d98000 8 > $DCC_PATH/config
    echo 0x17d98020 2 > $DCC_PATH/config
    # #EPSSFAST_SEQ_MEM_r register
    echo 0x17D10200 256 > $DCC_PATH/config
}

config_dcc_gict()
{
    echo 0x17120000 1  > $DCC_PATH/config
    echo 0x17120008 1  > $DCC_PATH/config
    echo 0x17120010 1  > $DCC_PATH/config
    echo 0x17120018 1  > $DCC_PATH/config
    echo 0x17120020 1  > $DCC_PATH/config
    echo 0x17120028 1  > $DCC_PATH/config
    echo 0x17120040 1  > $DCC_PATH/config
    echo 0x17120048 1  > $DCC_PATH/config
    echo 0x17120050 1  > $DCC_PATH/config
    echo 0x17120058 1  > $DCC_PATH/config
    echo 0x17120060 1  > $DCC_PATH/config
    echo 0x17120068 1  > $DCC_PATH/config
    echo 0x17120080 1  > $DCC_PATH/config
    echo 0x17120088 1  > $DCC_PATH/config
    echo 0x17120090 1  > $DCC_PATH/config
    echo 0x17120098 1  > $DCC_PATH/config
    echo 0x171200a0 1  > $DCC_PATH/config
    echo 0x171200a8 1  > $DCC_PATH/config
    echo 0x171200c0 1  > $DCC_PATH/config
    echo 0x171200c8 1  > $DCC_PATH/config
    echo 0x171200d0 1  > $DCC_PATH/config
    echo 0x171200d8 1  > $DCC_PATH/config
    echo 0x171200e0 1  > $DCC_PATH/config
    echo 0x171200e8 1  > $DCC_PATH/config
    echo 0x17120100 1  > $DCC_PATH/config
    echo 0x17120108 1  > $DCC_PATH/config
    echo 0x17120110 1  > $DCC_PATH/config
    echo 0x17120118 1  > $DCC_PATH/config
    echo 0x17120120 1  > $DCC_PATH/config
    echo 0x17120128 1  > $DCC_PATH/config
    echo 0x17120140 1  > $DCC_PATH/config
    echo 0x17120148 1  > $DCC_PATH/config
    echo 0x17120150 1  > $DCC_PATH/config
    echo 0x17120158 1  > $DCC_PATH/config
    echo 0x17120160 1  > $DCC_PATH/config
    echo 0x17120168 1  > $DCC_PATH/config
    echo 0x17120180 1  > $DCC_PATH/config
    echo 0x17120188 1  > $DCC_PATH/config
    echo 0x17120190 1  > $DCC_PATH/config
    echo 0x17120198 1  > $DCC_PATH/config
    echo 0x171201a0 1  > $DCC_PATH/config
    echo 0x171201a8 1  > $DCC_PATH/config
    echo 0x171201c0 1  > $DCC_PATH/config
    echo 0x171201c8 1  > $DCC_PATH/config
    echo 0x171201d0 1  > $DCC_PATH/config
    echo 0x171201d8 1  > $DCC_PATH/config
    echo 0x171201e0 1  > $DCC_PATH/config
    echo 0x171201e8 1  > $DCC_PATH/config
    echo 0x17120200 1  > $DCC_PATH/config
    echo 0x17120208 1  > $DCC_PATH/config
    echo 0x17120210 1  > $DCC_PATH/config
    echo 0x17120218 1  > $DCC_PATH/config
    echo 0x17120220 1  > $DCC_PATH/config
    echo 0x17120228 1  > $DCC_PATH/config
    echo 0x17120240 1  > $DCC_PATH/config
    echo 0x17120248 1  > $DCC_PATH/config
    echo 0x17120250 1  > $DCC_PATH/config
    echo 0x17120258 1  > $DCC_PATH/config
    echo 0x17120260 1  > $DCC_PATH/config
    echo 0x17120268 1  > $DCC_PATH/config
    echo 0x17120280 1  > $DCC_PATH/config
    echo 0x17120288 1  > $DCC_PATH/config
    echo 0x17120290 1  > $DCC_PATH/config
    echo 0x17120298 1  > $DCC_PATH/config
    echo 0x171202a0 1  > $DCC_PATH/config
    echo 0x171202a8 1  > $DCC_PATH/config
    echo 0x171202c0 1  > $DCC_PATH/config
    echo 0x171202c8 1  > $DCC_PATH/config
    echo 0x171202d0 1  > $DCC_PATH/config
    echo 0x171202d8 1  > $DCC_PATH/config
    echo 0x171202e0 1  > $DCC_PATH/config
    echo 0x171202e8 1  > $DCC_PATH/config
    echo 0x17120300 1  > $DCC_PATH/config
    echo 0x17120308 1  > $DCC_PATH/config
    echo 0x17120310 1  > $DCC_PATH/config
    echo 0x17120318 1  > $DCC_PATH/config
    echo 0x17120320 1  > $DCC_PATH/config
    echo 0x17120328 1  > $DCC_PATH/config
    echo 0x17120340 1  > $DCC_PATH/config
    echo 0x17120348 1  > $DCC_PATH/config
    echo 0x17120350 1  > $DCC_PATH/config
    echo 0x17120358 1  > $DCC_PATH/config
    echo 0x17120360 1  > $DCC_PATH/config
    echo 0x17120368 1  > $DCC_PATH/config
    echo 0x17120380 1  > $DCC_PATH/config
    echo 0x17120388 1  > $DCC_PATH/config
    echo 0x17120390 1  > $DCC_PATH/config
    echo 0x17120398 1  > $DCC_PATH/config
    echo 0x171203a0 1  > $DCC_PATH/config
    echo 0x171203a8 1  > $DCC_PATH/config
    echo 0x171203c0 1  > $DCC_PATH/config
    echo 0x171203c8 1  > $DCC_PATH/config
    echo 0x171203d0 1  > $DCC_PATH/config
    echo 0x171203d8 1  > $DCC_PATH/config
    echo 0x171203e0 1  > $DCC_PATH/config
    echo 0x171203e8 1  > $DCC_PATH/config
    echo 0x17120400 1  > $DCC_PATH/config
    echo 0x17120408 1  > $DCC_PATH/config
    echo 0x17120410 1  > $DCC_PATH/config
    echo 0x17120418 1  > $DCC_PATH/config
    echo 0x17120420 1  > $DCC_PATH/config
    echo 0x17120428 1  > $DCC_PATH/config
    echo 0x17120440 1  > $DCC_PATH/config
    echo 0x17120448 1  > $DCC_PATH/config
    echo 0x17120450 1  > $DCC_PATH/config
    echo 0x17120458 1  > $DCC_PATH/config
    echo 0x17120460 1  > $DCC_PATH/config
    echo 0x17120468 1  > $DCC_PATH/config
    echo 0x17120480 1  > $DCC_PATH/config
    echo 0x17120488 1  > $DCC_PATH/config
    echo 0x17120490 1  > $DCC_PATH/config
    echo 0x17120498 1  > $DCC_PATH/config
    echo 0x171204a0 1  > $DCC_PATH/config
    echo 0x171204a8 1  > $DCC_PATH/config
    echo 0x171204c0 1  > $DCC_PATH/config
    echo 0x171204c8 1  > $DCC_PATH/config
    echo 0x171204d0 1  > $DCC_PATH/config
    echo 0x171204d8 1  > $DCC_PATH/config
    echo 0x171204e0 1  > $DCC_PATH/config
    echo 0x171204e8 1  > $DCC_PATH/config
    echo 0x17120500 1  > $DCC_PATH/config
    echo 0x17120508 1  > $DCC_PATH/config
    echo 0x17120510 1  > $DCC_PATH/config
    echo 0x17120518 1  > $DCC_PATH/config
    echo 0x17120520 1  > $DCC_PATH/config
    echo 0x17120528 1  > $DCC_PATH/config
    echo 0x17120540 1  > $DCC_PATH/config
    echo 0x17120548 1  > $DCC_PATH/config
    echo 0x17120550 1  > $DCC_PATH/config
    echo 0x17120558 1  > $DCC_PATH/config
    echo 0x17120560 1  > $DCC_PATH/config
    echo 0x17120568 1  > $DCC_PATH/config
    echo 0x17120580 1  > $DCC_PATH/config
    echo 0x17120588 1  > $DCC_PATH/config
    echo 0x17120590 1  > $DCC_PATH/config
    echo 0x17120598 1  > $DCC_PATH/config
    echo 0x171205a0 1  > $DCC_PATH/config
    echo 0x171205a8 1  > $DCC_PATH/config
    echo 0x171205c0 1  > $DCC_PATH/config
    echo 0x171205c8 1  > $DCC_PATH/config
    echo 0x171205d0 1  > $DCC_PATH/config
    echo 0x171205d8 1  > $DCC_PATH/config
    echo 0x171205e0 1  > $DCC_PATH/config
    echo 0x171205e8 1  > $DCC_PATH/config
    echo 0x17120600 1  > $DCC_PATH/config
    echo 0x17120608 1  > $DCC_PATH/config
    echo 0x17120610 1  > $DCC_PATH/config
    echo 0x17120618 1  > $DCC_PATH/config
    echo 0x17120620 1  > $DCC_PATH/config
    echo 0x17120628 1  > $DCC_PATH/config
    echo 0x17120640 1  > $DCC_PATH/config
    echo 0x17120648 1  > $DCC_PATH/config
    echo 0x17120650 1  > $DCC_PATH/config
    echo 0x17120658 1  > $DCC_PATH/config
    echo 0x17120660 1  > $DCC_PATH/config
    echo 0x17120668 1  > $DCC_PATH/config
    echo 0x17120680 1  > $DCC_PATH/config
    echo 0x17120688 1  > $DCC_PATH/config
    echo 0x17120690 1  > $DCC_PATH/config
    echo 0x17120698 1  > $DCC_PATH/config
    echo 0x171206a0 1  > $DCC_PATH/config
    echo 0x171206a8 1  > $DCC_PATH/config
    echo 0x171206c0 1  > $DCC_PATH/config
    echo 0x171206c8 1  > $DCC_PATH/config
    echo 0x171206d0 1  > $DCC_PATH/config
    echo 0x171206d8 1  > $DCC_PATH/config
    echo 0x171206e0 1  > $DCC_PATH/config
    echo 0x171206e8 1  > $DCC_PATH/config
    echo 0x1712e000 1  > $DCC_PATH/config

}

config_dcc_lpm_pcu()
{
    #PCU -DCC for LPM path
    #  Read only registers
    echo 0x17800024  1  > $DCC_PATH/config
    echo 0x17800038  6 > $DCC_PATH/config
    echo 0x17800058  4 > $DCC_PATH/config
    echo 0x1780006C  1  > $DCC_PATH/config
    echo 0x178000F0  2 > $DCC_PATH/config
    echo 0x17810024  1  > $DCC_PATH/config
    echo 0x17810038  6 > $DCC_PATH/config
    echo 0x17810058  4 > $DCC_PATH/config
    echo 0x1781006C  1  > $DCC_PATH/config
    echo 0x178100F0  2 > $DCC_PATH/config
    echo 0x17820010  1  > $DCC_PATH/config
    echo 0x17820024  1  > $DCC_PATH/config
    echo 0x17820038  6 > $DCC_PATH/config
    echo 0x17820058  4 > $DCC_PATH/config
    echo 0x178200F0  2 > $DCC_PATH/config
    echo 0x17830010  1  > $DCC_PATH/config
    echo 0x17830024  1  > $DCC_PATH/config
    echo 0x17830038  6 > $DCC_PATH/config
    echo 0x17830058  4 > $DCC_PATH/config
    echo 0x178300F0  2 > $DCC_PATH/config
    echo 0x17840010  1  > $DCC_PATH/config
    echo 0x17840024  1  > $DCC_PATH/config
    echo 0x17840038  6 > $DCC_PATH/config
    echo 0x17840058  4 > $DCC_PATH/config
    echo 0x178400F0  2 > $DCC_PATH/config
    echo 0x17850010  1  > $DCC_PATH/config
    echo 0x17850024  1  > $DCC_PATH/config
    echo 0x17850038  6 > $DCC_PATH/config
    echo 0x17850058  4 > $DCC_PATH/config
    echo 0x178500F0  2 > $DCC_PATH/config
    echo 0x17860010  1  > $DCC_PATH/config
    echo 0x17860024  1  > $DCC_PATH/config
    echo 0x17860038  6 > $DCC_PATH/config
    echo 0x17860058  4 > $DCC_PATH/config
    echo 0x178600F0  2 > $DCC_PATH/config
    echo 0x17870010  1  > $DCC_PATH/config
    echo 0x17870024  1  > $DCC_PATH/config
    echo 0x17870038  6 > $DCC_PATH/config
    echo 0x17870058  4 > $DCC_PATH/config
    echo 0x178700F0  2 > $DCC_PATH/config
    echo 0x17880010  1  > $DCC_PATH/config
    echo 0x17880024  1  > $DCC_PATH/config
    echo 0x17880038  6 > $DCC_PATH/config
    echo 0x17890010  1  > $DCC_PATH/config
    echo 0x17890024  1  > $DCC_PATH/config
    echo 0x17890038  6 > $DCC_PATH/config
    echo 0x178B0010  1  > $DCC_PATH/config
    echo 0x178B0024  1  > $DCC_PATH/config
    echo 0x178B0038  6 > $DCC_PATH/config
    echo 0x178B006C  5 > $DCC_PATH/config
    echo 0x178B0084  1  > $DCC_PATH/config
    echo 0x178B00F4  5 > $DCC_PATH/config
    echo 0x178B0118  9 > $DCC_PATH/config
    echo 0x178B0158  5 > $DCC_PATH/config
    echo 0x178B0170  2 > $DCC_PATH/config
    echo 0x178B0188  5 > $DCC_PATH/config
    echo 0x178B01AC  6 > $DCC_PATH/config
    echo 0x178B01C8 1  > $DCC_PATH/config

}
config_dcc_lpm()
{
    #PPU PWPR/PWSR/DISR register
    echo 0x178B0204 1  > $DCC_PATH/config
    echo 0x178B0244 1  > $DCC_PATH/config
    echo 0x17E30000 1  > $DCC_PATH/config
    echo 0x17E30008 1  > $DCC_PATH/config
    echo 0x17E30010 1  > $DCC_PATH/config
    echo 0x17E80000 1  > $DCC_PATH/config
    echo 0x17E80008 1  > $DCC_PATH/config
    echo 0x17E80010 1  > $DCC_PATH/config
    echo 0x17F80000 1  > $DCC_PATH/config
    echo 0x17F80008 1  > $DCC_PATH/config
    echo 0x17F80010 1  > $DCC_PATH/config
    echo 0x18080000 1  > $DCC_PATH/config
    echo 0x18080008 1  > $DCC_PATH/config
    echo 0x18080010 1  > $DCC_PATH/config
    echo 0x18180000 1  > $DCC_PATH/config
    echo 0x18180008 1  > $DCC_PATH/config
    echo 0x18180010 1  > $DCC_PATH/config
    echo 0x18280000 1  > $DCC_PATH/config
    echo 0x18280008 1  > $DCC_PATH/config
    echo 0x18280010 1  > $DCC_PATH/config
    echo 0x18380000 1  > $DCC_PATH/config
    echo 0x18380008 1  > $DCC_PATH/config
    echo 0x18380010 1  > $DCC_PATH/config
    echo 0x18480000 1  > $DCC_PATH/config
    echo 0x18480008 1  > $DCC_PATH/config
    echo 0x18480010 1  > $DCC_PATH/config
    echo 0x18580000 1  > $DCC_PATH/config
    echo 0x18580008 1  > $DCC_PATH/config
    echo 0x18580010 1  > $DCC_PATH/config

}
config_dcc_core()
{
    # core hang
    echo 0x1780005C 1 > $DCC_PATH/config
    echo 0x1781005C 1 > $DCC_PATH/config
    echo 0x1782005C 1 > $DCC_PATH/config
    echo 0x1783005C 1 > $DCC_PATH/config
    echo 0x1784005C 1 > $DCC_PATH/config
    echo 0x1785005C 1 > $DCC_PATH/config
    echo 0x1786005C 1 > $DCC_PATH/config
    echo 0x1787005C 1 > $DCC_PATH/config
    echo 0x1740003C 1 > $DCC_PATH/config

    #MIBU Debug registers
    echo 0x17600238 1 > $DCC_PATH/config
    echo 0x17600240 11 > $DCC_PATH/config
    echo 0x17600274 1 >  $DCC_PATH/config
    echo 0x17600530 > $DCC_PATH/config
    echo 0x1760051C > $DCC_PATH/config
    echo 0x17600524 > $DCC_PATH/config
    echo 0x1760052C > $DCC_PATH/config
    echo 0x17600518 > $DCC_PATH/config
    echo 0x17600520 > $DCC_PATH/config
    echo 0x17600528 > $DCC_PATH/config

    #CHI (GNOC) Hang counters
    echo 0x17600404 4 > $DCC_PATH/config
    echo 0x1760041C 4 > $DCC_PATH/config
    echo 0x17600434 1 > $DCC_PATH/config
    echo 0x1760043C 1 > $DCC_PATH/config
    echo 0x17600440 1 > $DCC_PATH/config

    #SYSCO and other misc debug
    echo 0x17400438 1 > $DCC_PATH/config
    echo 0x17600044 1 > $DCC_PATH/config
    echo 0x17600500 1 > $DCC_PATH/config

    #QFPROM_CORR_PTE_ROW0_MSB
    echo 0x221C209C > $DCC_PATH/config

    #PPUHWSTAT_STS
    echo 0x17600504 4 > $DCC_PATH/config

    #CPRh
    echo 0x17900908 1 > $DCC_PATH/config
    echo 0x17900C18 1 > $DCC_PATH/config
    echo 0x17901908 1 > $DCC_PATH/config
    echo 0x17901C18 1 > $DCC_PATH/config

    echo 0x17B90810 3 > $DCC_PATH/config
    echo 0x17B90C50 3 > $DCC_PATH/config
    echo 0x17B93A04 2 > $DCC_PATH/config
    echo 0x17B93C94 1 > $DCC_PATH/config

    echo 0x17BA0810 3 > $DCC_PATH/config
    echo 0x17BA0C50 3 > $DCC_PATH/config
    echo 0x17BA3A04 2 > $DCC_PATH/config
    echo 0x17BA3C94 1 > $DCC_PATH/config

    echo 0x17B93000 80 > $DCC_PATH/config
    echo 0x17BA3000 80 > $DCC_PATH/config

    #rpmh
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config

    #apm
    echo 0x17B00000 1 > $DCC_PATH/config

    #L3-ACD
    echo 0x17A94030 1 > $DCC_PATH/config
    echo 0x17A9408C 1 > $DCC_PATH/config
    echo 0x17A9409C 0x78 > $DCC_PATH/config_write
    echo 0x17A9409C 0x0  > $DCC_PATH/config_write
    echo 0x17A94048 0x1  > $DCC_PATH/config_write
    echo 0x17A94090 0x0  > $DCC_PATH/config_write
    echo 0x17A94090 0x25 > $DCC_PATH/config_write
    echo 0x17A94098 1 > $DCC_PATH/config
    echo 0x17A94048 0x1D > $DCC_PATH/config_write
    echo 0x17A94090 0x0  > $DCC_PATH/config_write
    echo 0x17A94090 0x25 > $DCC_PATH/config_write
    echo 0x17A94098 1 > $DCC_PATH/config

    #SILVER-ACD
    echo 0x17A90030 1 > $DCC_PATH/config
    echo 0x17A9008C 1 > $DCC_PATH/config
    echo 0x17A9009C 0x78 > $DCC_PATH/config_write
    echo 0x17A9009C 0x0  > $DCC_PATH/config_write
    echo 0x17A90048 0x1  > $DCC_PATH/config_write
    echo 0x17A90090 0x0  > $DCC_PATH/config_write
    echo 0x17A90090 0x25 > $DCC_PATH/config_write
    echo 0x17A90098 1 > $DCC_PATH/config
    echo 0x17A90048 0x1D > $DCC_PATH/config_write
    echo 0x17A90090 0x0  > $DCC_PATH/config_write
    echo 0x17A90090 0x25 > $DCC_PATH/config_write
    echo 0x17A90098 1 > $DCC_PATH/config


    #GOLD-ACD
    echo 0x17A92030 1 > $DCC_PATH/config
    echo 0x17A9208C 1 > $DCC_PATH/config
    echo 0x17A9209C 0x78 > $DCC_PATH/config_write
    echo 0x17A9209C 0x0  > $DCC_PATH/config_write
    echo 0x17A92048 0x1  > $DCC_PATH/config_write
    echo 0x17A92090 0x0  > $DCC_PATH/config_write
    echo 0x17A92090 0x25 > $DCC_PATH/config_write
    echo 0x17A92098 1 > $DCC_PATH/config
    echo 0x17A92048 0x1D > $DCC_PATH/config_write
    echo 0x17A92090 0x0  > $DCC_PATH/config_write
    echo 0x17A92090 0x25 > $DCC_PATH/config_write
    echo 0x17A92098 1 > $DCC_PATH/config

    #GOLDPLUS-ACD
    echo 0x17A96030 1 > $DCC_PATH/config
    echo 0x17A9608C 1 > $DCC_PATH/config
    echo 0x17A9609C 0x78 > $DCC_PATH/config_write
    echo 0x17A9609C 0x0  > $DCC_PATH/config_write
    echo 0x17A96048 0x1  > $DCC_PATH/config_write
    echo 0x17A96090 0x0  > $DCC_PATH/config_write
    echo 0x17A96090 0x25 > $DCC_PATH/config_write
    echo 0x17A96098 1 > $DCC_PATH/config
    echo 0x17A96048 0x1D > $DCC_PATH/config_write
    echo 0x17A96090 0x0  > $DCC_PATH/config_write
    echo 0x17A96090 0x25 > $DCC_PATH/config_write
    echo 0x17A96098 1 > $DCC_PATH/config

    echo 0x17D98024 1 > $DCC_PATH/config
    echo 0x13822000 1 1 > $DCC_PATH/config

    #Security Control Core for Binning info
    echo 0x221C20A4 1 > $DCC_PATH/config

    #SoC version
    echo 0x01FC8000 1 > $DCC_PATH/config

    #WDOG BIT Config
    echo 0x17400038 1 > $DCC_PATH/config

    #pimem ramblur registers
    echo 0x610000 1  > $DCC_PATH/config
    echo 0x610058 8 > $DCC_PATH/config
    echo 0x610100 1  > $DCC_PATH/config
    echo 0x610108 7 > $DCC_PATH/config
    echo 0x610128 1  > $DCC_PATH/config
    echo 0x6101B8 1  > $DCC_PATH/config

    #Curr Freq
    echo 0x17D91020 > $DCC_PATH/config
    echo 0x17D92020 > $DCC_PATH/config
    echo 0x17D93020 > $DCC_PATH/config
    echo 0x17D90020 > $DCC_PATH/config

    #OSM Seq curr addr
    echo 0x17D9134C > $DCC_PATH/config
    echo 0x17D9234C > $DCC_PATH/config
    echo 0x17D9334C > $DCC_PATH/config
    echo 0x17D9034C > $DCC_PATH/config

    #DCVS_IN_PROGRESS
    echo 0x17D91300 > $DCC_PATH/config
    echo 0x17D92300 > $DCC_PATH/config
    echo 0x17D93300 > $DCC_PATH/config
    echo 0x17D90300 > $DCC_PATH/config
}

config_dcc_turing()
{
    #ADSP
    echo 0x30B0208 3 > $DCC_PATH/config
    echo 0x30B0228 3 > $DCC_PATH/config
    echo 0x30B0248 3 > $DCC_PATH/config
    echo 0x30B0268 3 > $DCC_PATH/config
    echo 0x30B0288 3 > $DCC_PATH/config
    echo 0x30B02a8 3 > $DCC_PATH/config
    echo 0x30B0404 2 > $DCC_PATH/config
    echo 0x3480208 3 > $DCC_PATH/config
    echo 0x3480228 3 > $DCC_PATH/config
    echo 0x3480248 3 > $DCC_PATH/config
    echo 0x3480268 3 > $DCC_PATH/config
    echo 0x3480288 3 > $DCC_PATH/config
    echo 0x34802a8 3 > $DCC_PATH/config
    #CDSP
    echo 0x320A4208 2 > $DCC_PATH/config
    echo 0x320A4228 3 > $DCC_PATH/config
    echo 0x320A4248 3 > $DCC_PATH/config
    echo 0x320A4268 3 > $DCC_PATH/config
    echo 0x320A4288 3 > $DCC_PATH/config
    echo 0x320A42A8 3 > $DCC_PATH/config
    echo 0x320A4400 3 > $DCC_PATH/config
    echo 0x32302028 1 > $DCC_PATH/config
    echo 0x323B0208 3 > $DCC_PATH/config
    echo 0x323B0228 3 > $DCC_PATH/config
    echo 0x323B0248 3 > $DCC_PATH/config
    echo 0x323B0268 3 > $DCC_PATH/config
    echo 0x323B0288 3 > $DCC_PATH/config
    echo 0x323B02A8 3 > $DCC_PATH/config
    echo 0x323B0400 3 > $DCC_PATH/config
}

config_dcc_modem()
{
    echo 0x4080304 1  > $DCC_PATH/config
    echo 0x4082028 1  > $DCC_PATH/config
    echo 0x4130208 3 > $DCC_PATH/config
    echo 0x4130228 3 > $DCC_PATH/config
    echo 0x4130248 3 > $DCC_PATH/config
    echo 0x4130268 3 > $DCC_PATH/config
    echo 0x4130288 3 > $DCC_PATH/config
    echo 0x41302A8 3 > $DCC_PATH/config
    echo 0x4130400 3 > $DCC_PATH/config
    echo 0x4200208 3 > $DCC_PATH/config
    echo 0x4200228 3 > $DCC_PATH/config
    echo 0x4200248 3 > $DCC_PATH/config
    echo 0x4200268 3 > $DCC_PATH/config
    echo 0x4200288 3 > $DCC_PATH/config
    echo 0x42002A8 3 > $DCC_PATH/config
    echo 0x4200400 3 > $DCC_PATH/config
}

config_dcc_wpss()
{
    echo 0x8A00304 1  > $DCC_PATH/config
    echo 0x8A02028 1  > $DCC_PATH/config
    echo 0x8AC0208 3 > $DCC_PATH/config
    echo 0x8AC0228 3 > $DCC_PATH/config
    echo 0x8AC0248 3 > $DCC_PATH/config
    echo 0x8AC0268 3 > $DCC_PATH/config
    echo 0x8AC0288 3 > $DCC_PATH/config
    echo 0x8AC02AC 2 > $DCC_PATH/config
    echo 0x8AC02a8 1  > $DCC_PATH/config
    echo 0x8AC0400 3 > $DCC_PATH/config
}

config_dcc_pll_status()
{
    echo 0x17A80000 17 > $DCC_PATH/config
    echo 0x17A84000 17 > $DCC_PATH/config
    echo 0x17A90000 25 > $DCC_PATH/config
    echo 0x17A90080 16 > $DCC_PATH/config
    echo 0x17A900CC 5 > $DCC_PATH/config
    echo 0x17A900E4 2 > $DCC_PATH/config
    echo 0x17A900F0 1  > $DCC_PATH/config
    echo 0x17A900F8 1  > $DCC_PATH/config
    echo 0x17A90118 1  > $DCC_PATH/config
    echo 0x17A94000 25 > $DCC_PATH/config
    echo 0x17A94080 16 > $DCC_PATH/config
    echo 0x17A940CC 5 > $DCC_PATH/config
    echo 0x17A940E4 2 > $DCC_PATH/config
    echo 0x17A940F0 1  > $DCC_PATH/config
    echo 0x17A940F8 1  > $DCC_PATH/config
    echo 0x17A94118 1  > $DCC_PATH/config
    echo 0x17AA0000 44 > $DCC_PATH/config
    echo 0x17AA00BC 1  > $DCC_PATH/config
    echo 0x17AA00FC 20 > $DCC_PATH/config
    echo 0x17AA0200 2 > $DCC_PATH/config
    echo 0x17AA0300 1  > $DCC_PATH/config
    echo 0x17AA0400 1  > $DCC_PATH/config
    echo 0x17AA0500 1  > $DCC_PATH/config
    echo 0x17AA0600 1  > $DCC_PATH/config
    echo 0x17AA0700 5 > $DCC_PATH/config
    echo 0x17D90000 4 > $DCC_PATH/config
    echo 0x17D90014 26 > $DCC_PATH/config
    echo 0x17D90080 5 > $DCC_PATH/config
    echo 0x17D900B0 1  > $DCC_PATH/config
    echo 0x17D900B8 2 > $DCC_PATH/config
    echo 0x17D900D0 9 > $DCC_PATH/config
    echo 0x17D90100 1  > $DCC_PATH/config
    echo 0x17D90200 1  > $DCC_PATH/config
    echo 0x17D90300 5 > $DCC_PATH/config
    echo 0x17D90320 1  > $DCC_PATH/config
    echo 0x17D9034C 2 > $DCC_PATH/config
    echo 0x17D90360 5 > $DCC_PATH/config
    echo 0x17D903B0 6 > $DCC_PATH/config
    echo 0x17D903E0 2 > $DCC_PATH/config
    echo 0x17D90404 3 > $DCC_PATH/config
    echo 0x17D90420 1  > $DCC_PATH/config
    echo 0x17D90430 1  > $DCC_PATH/config
    echo 0x17D90450 1  > $DCC_PATH/config
    echo 0x17D90470 6 > $DCC_PATH/config
    echo 0x17D91000 4 > $DCC_PATH/config
    echo 0x17D91014 26 > $DCC_PATH/config
    echo 0x17D91080 5 > $DCC_PATH/config
    echo 0x17D910B0 1  > $DCC_PATH/config
    echo 0x17D910B8 2 > $DCC_PATH/config
    echo 0x17D910D0 9 > $DCC_PATH/config
    echo 0x17D91100 1  > $DCC_PATH/config
    echo 0x17D91200 1  > $DCC_PATH/config
    echo 0x17D91300 5 > $DCC_PATH/config
    echo 0x17D91320 1  > $DCC_PATH/config
    echo 0x17D9134C 2 > $DCC_PATH/config
    echo 0x17D91360 5 > $DCC_PATH/config
    echo 0x17D913B0 6 > $DCC_PATH/config
    echo 0x17D913E0 2 > $DCC_PATH/config
    echo 0x17D91404 3 > $DCC_PATH/config
    echo 0x17D91420 1  > $DCC_PATH/config
    echo 0x17D91430 1  > $DCC_PATH/config
    echo 0x17D91450 1  > $DCC_PATH/config
    echo 0x17D91470 4 > $DCC_PATH/config
    echo 0x17D91480 1  > $DCC_PATH/config
}

config_dcc_gcc()
{
    echo 0x11C018 7 > $DCC_PATH/config
    echo 0x178040 1  > $DCC_PATH/config
    echo 0x190890 1  > $DCC_PATH/config
    echo 0x199014 7 > $DCC_PATH/config
    echo 0x19D014 7 > $DCC_PATH/config
}

config_dcc_phy_tcsr()
{
    echo 0x1FD5000 10 > $DCC_PATH/config
    echo 0x1FD502C 1  > $DCC_PATH/config
    echo 0x1FD5030 4 > $DCC_PATH/config
    echo 0x88E7000 51 > $DCC_PATH/config
}

config_dcc_anoc_pcie()
{
    #RPMH_SYS_NOC_CMD_DFSR
    echo 0x17603C 1 > $DCC_PATH/config
    echo 0x16C000 1 > $DCC_PATH/config
    echo 0x16C01C 1 > $DCC_PATH/config
}


config_dcc_pcie()
{
    echo 0x110040 7 > $DCC_PATH/config
    echo 0x110064 1  > $DCC_PATH/config
    echo 0x110070 2 > $DCC_PATH/config
    echo 0x111004 2 > $DCC_PATH/config
    echo 0x16B018 3 > $DCC_PATH/config
    echo 0x16B02C 1  > $DCC_PATH/config
    echo 0x16B038 2 > $DCC_PATH/config
    echo 0x16B048 1  > $DCC_PATH/config
    echo 0x16B054 1  > $DCC_PATH/config
    echo 0x16B098 1  > $DCC_PATH/config
    echo 0x1C00000 1  > $DCC_PATH/config
    echo 0x1C00024 2 > $DCC_PATH/config
    echo 0x1C001B0 1  > $DCC_PATH/config
    echo 0x1C001B0   1  > $DCC_PATH/config
    echo 0x1C00224 1  > $DCC_PATH/config
    echo 0x1C00230	 1  > $DCC_PATH/config
    echo 0x1C002B0 1  > $DCC_PATH/config
    echo 0x1C003C0 1  > $DCC_PATH/config
    echo 0x1C004D0 2 > $DCC_PATH/config
    echo 0x1C00500 1  > $DCC_PATH/config
    echo 0x1C00630 1  > $DCC_PATH/config
    echo 0x1C061C8	 8 > $DCC_PATH/config
    echo 0x1C061F8 1  > $DCC_PATH/config
    echo 0x1C06214	 1  > $DCC_PATH/config
    echo 0x1C06214	 11 > $DCC_PATH/config
    echo 0x1C06600	 2 > $DCC_PATH/config
    echo 0x1C06804 1  > $DCC_PATH/config
    echo 0x1C06A00	 4 > $DCC_PATH/config
    echo 0x1C06A18 1  > $DCC_PATH/config
    echo 0x1C06C20  1  > $DCC_PATH/config
    echo 0x1C07204 1  > $DCC_PATH/config
    echo 0x1FF1100 1  > $DCC_PATH/config
    echo 0x60000080	 1  > $DCC_PATH/config
    echo 0x60000104	 1  > $DCC_PATH/config
    echo 0x60000110 1  > $DCC_PATH/config
    echo 0x60000204	 1  > $DCC_PATH/config
    echo 0x60000730 4 > $DCC_PATH/config

}


config_dcc_rng()
{
    echo 0x10C0000 4  > $DCC_PATH/config
    echo 0x10C1000 2  > $DCC_PATH/config
    echo 0x10C1010 7  > $DCC_PATH/config
    echo 0x10C1100 3  > $DCC_PATH/config
    echo 0x10C1110 5  > $DCC_PATH/config
    echo 0x10C1130 2  > $DCC_PATH/config
    echo 0x10C113C 2  > $DCC_PATH/config
    echo 0x10C1148 3  > $DCC_PATH/config
    echo 0x10C2000 1  > $DCC_PATH/config
    echo 0x10CF004 1  > $DCC_PATH/config
}

config_gpu()
{
    echo 0x0129000  1  > $DCC_PATH/config
    echo 0x012903c  1  > $DCC_PATH/config
    echo 0x0171004  1  > $DCC_PATH/config
    echo 0x017100c  6 > $DCC_PATH/config
    echo 0x017115c  1  > $DCC_PATH/config
    echo 0x017b000  1  > $DCC_PATH/config
    echo 0x017b03c  1  > $DCC_PATH/config
    echo 0x017c000  1  > $DCC_PATH/config
    echo 0x017c03c  1  > $DCC_PATH/config
    echo 0x017d000  1  > $DCC_PATH/config
    echo 0x017d03c  1  > $DCC_PATH/config
    echo 0x017e000  1  > $DCC_PATH/config
    echo 0x017e03c  1  > $DCC_PATH/config
    echo 0x3d00000  1  > $DCC_PATH/config
    echo 0x3d00008  1  > $DCC_PATH/config
    echo 0x3d00020  6  > $DCC_PATH/config
    echo 0x3d00040  4  > $DCC_PATH/config
    echo 0x3d00054  2  > $DCC_PATH/config
    echo 0x3d00060  1  > $DCC_PATH/config
    echo 0x3d00068  1  > $DCC_PATH/config
    echo 0x3d00070  1  > $DCC_PATH/config
    echo 0x3d000a0  4  > $DCC_PATH/config
    echo 0x3d000b4  13 > $DCC_PATH/config
    echo 0x3d00100  20 > $DCC_PATH/config
    echo 0x3d00188  5  > $DCC_PATH/config
    echo 0x3d001a4  6  > $DCC_PATH/config
    echo 0x3d001c4  2  > $DCC_PATH/config
    echo 0x3d001d0  1  > $DCC_PATH/config
    echo 0x3d001d8  2 > $DCC_PATH/config
    echo 0x3d001fc  28 > $DCC_PATH/config
    echo 0x3d00274  19 > $DCC_PATH/config
    echo 0x3d002c8  35 > $DCC_PATH/config
    echo 0x3d0035c  12 > $DCC_PATH/config
    echo 0x3d00394  2 > $DCC_PATH/config
    echo 0x3d003a4  9 > $DCC_PATH/config
    echo 0x3d003d0  3 > $DCC_PATH/config
    echo 0x3d003e4  16 > $DCC_PATH/config
    echo 0x3d0042c  4 > $DCC_PATH/config
    echo 0x3d00444  1  > $DCC_PATH/config
    echo 0x3d00450  9 > $DCC_PATH/config
    echo 0x3d0047c  3 > $DCC_PATH/config
    echo 0x3d00494  1  > $DCC_PATH/config
    echo 0x3d0049c  1  > $DCC_PATH/config
    echo 0x3d004a4  1  > $DCC_PATH/config
    echo 0x3d004ac  7 > $DCC_PATH/config
    echo 0x3d004d0  5 > $DCC_PATH/config
    echo 0x3d004e8  1  > $DCC_PATH/config
    echo 0x3d004f0  4 > $DCC_PATH/config
    echo 0x3d00508  15 > $DCC_PATH/config
    echo 0x3d0054c  3 > $DCC_PATH/config
    echo 0x3d00560  2 > $DCC_PATH/config
    echo 0x3d00570  1  > $DCC_PATH/config
    echo 0x3d00598  20 > $DCC_PATH/config
    echo 0x3d00680  1  > $DCC_PATH/config
    echo 0x3d00f80  1  > $DCC_PATH/config
    echo 0x3d00fc0  1  > $DCC_PATH/config
    echo 0x3d01100  1  > $DCC_PATH/config
    echo 0x3d02000  11 > $DCC_PATH/config
    echo 0x3d0204c  12 > $DCC_PATH/config
    echo 0x3d02080  4 > $DCC_PATH/config
    echo 0x3d020d8  9 > $DCC_PATH/config
    echo 0x3d02100  8 > $DCC_PATH/config
    echo 0x3d0212c  5 > $DCC_PATH/config
    echo 0x3d022c0  12 > $DCC_PATH/config
    echo 0x3d02300  12 > $DCC_PATH/config
    echo 0x3d0239c  5 > $DCC_PATH/config
    echo 0x3d0f000  12 > $DCC_PATH/config
    echo 0x3d0f100  3 > $DCC_PATH/config
    echo 0x3d0f114  3 > $DCC_PATH/config
    echo 0x3d0f124  6 > $DCC_PATH/config
    echo 0x3d3c000  3 > $DCC_PATH/config
    echo 0x3d3d000  1  > $DCC_PATH/config
    echo 0x3d3e000  4 > $DCC_PATH/config
    echo 0x3d3f000  2 > $DCC_PATH/config
    echo 0x3d50000  21 > $DCC_PATH/config
    echo 0x3d500d0  1  > $DCC_PATH/config
    echo 0x3d500d8  1  > $DCC_PATH/config
    echo 0x3d50100  3 > $DCC_PATH/config
    echo 0x3d50110  2 > $DCC_PATH/config
    echo 0x3d5011c  1  > $DCC_PATH/config
    echo 0x3d50200  5 > $DCC_PATH/config
    echo 0x3d50400  5 > $DCC_PATH/config
    echo 0x3d50450  1  > $DCC_PATH/config
    echo 0x3d50460  2 > $DCC_PATH/config
    echo 0x3d50490  12 > $DCC_PATH/config
    echo 0x3d50550  1  > $DCC_PATH/config
    echo 0x3d50d00  2 > $DCC_PATH/config
    echo 0x3d50d10  1  > $DCC_PATH/config
    echo 0x3d50d18  13 > $DCC_PATH/config
    echo 0x3d50fe0  1  > $DCC_PATH/config
    echo 0x3d50ff8  1  > $DCC_PATH/config
    echo 0x3d51010  1  > $DCC_PATH/config
    echo 0x3d51028  1  > $DCC_PATH/config
    echo 0x3d51280  1  > $DCC_PATH/config
    echo 0x3d51520  1  > $DCC_PATH/config
    echo 0x3d51538  1  > $DCC_PATH/config
    echo 0x3d51550  1  > $DCC_PATH/config
    echo 0x3d517c0  1  > $DCC_PATH/config
    echo 0x3d51a60  1  > $DCC_PATH/config
    echo 0x3d51a78  1  > $DCC_PATH/config
    echo 0x3d51a90  1  > $DCC_PATH/config
    echo 0x3d51aa8  1  > $DCC_PATH/config
    echo 0x3d51d00  1  > $DCC_PATH/config
    echo 0x3d51fa0  1  > $DCC_PATH/config
    echo 0x3d51fb8  1  > $DCC_PATH/config
    echo 0x3d52240  1  > $DCC_PATH/config
    echo 0x3d52258  1  > $DCC_PATH/config
    echo 0x3d524e0  1  > $DCC_PATH/config
    echo 0x3d64000  13 > $DCC_PATH/config
    echo 0x3d6403c  1  > $DCC_PATH/config
    echo 0x3d66000  6 > $DCC_PATH/config
    echo 0x3d67000  1  > $DCC_PATH/config
    echo 0x3d68000  5 > $DCC_PATH/config
    echo 0x3d68020  11 > $DCC_PATH/config
    echo 0x3d68050  1  > $DCC_PATH/config
    echo 0x3d6805c  1  > $DCC_PATH/config
    echo 0x3d68064  1  > $DCC_PATH/config
    echo 0x3d68088  1  > $DCC_PATH/config
    echo 0x3d68090  6 > $DCC_PATH/config
    echo 0x3d680fc  31 > $DCC_PATH/config
    echo 0x3d68180  4 > $DCC_PATH/config
    echo 0x3d68194  2 > $DCC_PATH/config
    echo 0x3d681a0  15 > $DCC_PATH/config
    echo 0x3d681e0  4 > $DCC_PATH/config
    echo 0x3d69000  23 > $DCC_PATH/config
    echo 0x3d69080  14 > $DCC_PATH/config
    echo 0x3d690c0  2 > $DCC_PATH/config
    echo 0x3d690d4  1  > $DCC_PATH/config
    echo 0x3d690dc  1  > $DCC_PATH/config
    echo 0x3d690e8  1  > $DCC_PATH/config
    echo 0x3d69108  1  > $DCC_PATH/config
    echo 0x3d69158  3 > $DCC_PATH/config
    echo 0x3d6916c  3 > $DCC_PATH/config
    echo 0x3d6917c  4 > $DCC_PATH/config
    echo 0x3d7d000  12 > $DCC_PATH/config
    echo 0x3d7d03c  3 > $DCC_PATH/config
    echo 0x3d7d400  1  > $DCC_PATH/config
    echo 0x3d7d41c  1  > $DCC_PATH/config
    echo 0x3d7d424  3 > $DCC_PATH/config
    echo 0x3d7dc58  1  > $DCC_PATH/config
    echo 0x3d7dc94  1  > $DCC_PATH/config
    echo 0x3d7dca4  1  > $DCC_PATH/config
    echo 0x3d7dd58  2 > $DCC_PATH/config
    echo 0x3d7df80  2 > $DCC_PATH/config
    echo 0x3d7df90  2 > $DCC_PATH/config
    echo 0x3d7dfa0  2 > $DCC_PATH/config
    echo 0x3d7dfb0  2 > $DCC_PATH/config
    echo 0x3d7e000  5 > $DCC_PATH/config
    echo 0x3d7e01c  2 > $DCC_PATH/config
    echo 0x3d7e02c  2 > $DCC_PATH/config
    echo 0x3d7e03c  1  > $DCC_PATH/config
    echo 0x3d7e044  1  > $DCC_PATH/config
    echo 0x3d7e04c  5 > $DCC_PATH/config
    echo 0x3d7e064  4 > $DCC_PATH/config
    echo 0x3d7e090  13 > $DCC_PATH/config
    echo 0x3d7e100  2 > $DCC_PATH/config
    echo 0x3d7e130  1  > $DCC_PATH/config
    echo 0x3d7e140  1  > $DCC_PATH/config
    echo 0x3d7e500  2 > $DCC_PATH/config
    echo 0x3d7e50c  1  > $DCC_PATH/config
    echo 0x3d7e520  1  > $DCC_PATH/config
    echo 0x3d7e53c  1  > $DCC_PATH/config
    echo 0x3d7e550  2 > $DCC_PATH/config
    echo 0x3d7e574  1  > $DCC_PATH/config
    echo 0x3d7e5c0  1  > $DCC_PATH/config
    echo 0x3d7e5f0  3 > $DCC_PATH/config
    echo 0x3d7e600  2 > $DCC_PATH/config
    echo 0x3d7e610  3 > $DCC_PATH/config
    echo 0x3d7e648  2 > $DCC_PATH/config
    echo 0x3d7e658  9 > $DCC_PATH/config
    echo 0x3d7e700  16 > $DCC_PATH/config
    echo 0x3d7e7c4  1  > $DCC_PATH/config
    echo 0x3d7e7e0  3 > $DCC_PATH/config
    echo 0x3d7e7f0  1  > $DCC_PATH/config
    echo 0x3d7e800  4 > $DCC_PATH/config
    echo 0x3d7f050  1  > $DCC_PATH/config
    echo 0x3d7f060  2 > $DCC_PATH/config
    echo 0x3d7f080  1  > $DCC_PATH/config
    echo 0x3d7f090  3 > $DCC_PATH/config
    echo 0x3d80080  1  > $DCC_PATH/config
    echo 0x3d800d0  3 > $DCC_PATH/config
    echo 0x3d80c80  3 > $DCC_PATH/config
    echo 0x3d80c90  3 > $DCC_PATH/config
    echo 0x3d80ca0  3 > $DCC_PATH/config
    echo 0x3d80d40  1  > $DCC_PATH/config
    echo 0x3d8e100  8 > $DCC_PATH/config
    echo 0x3d8ec00  2 > $DCC_PATH/config
    echo 0x3d8ec0c  1  > $DCC_PATH/config
    echo 0x3d8ec14  10 > $DCC_PATH/config
    echo 0x3d8ec40  4 > $DCC_PATH/config
    echo 0x3d8ec54  2 > $DCC_PATH/config
    echo 0x3d8eca0  1  > $DCC_PATH/config
    echo 0x3d8ecc0  1  > $DCC_PATH/config
    echo 0x3d9200c  3 > $DCC_PATH/config
    echo 0x3d93000  1  > $DCC_PATH/config
    echo 0x3d94000  3 > $DCC_PATH/config
    echo 0x3d95000  5 > $DCC_PATH/config
    echo 0x3d96000  5 > $DCC_PATH/config
    echo 0x3d97000  5 > $DCC_PATH/config
    echo 0x3d98000  5 > $DCC_PATH/config
    echo 0x3d99000  7 > $DCC_PATH/config
    echo 0x3d99054  9 > $DCC_PATH/config
    echo 0x3d9907c  25 > $DCC_PATH/config
    echo 0x3d990e4  3 > $DCC_PATH/config
    echo 0x3d990f4  3 > $DCC_PATH/config
    echo 0x3d9910c  2 > $DCC_PATH/config
    echo 0x3d991e0  3 > $DCC_PATH/config
    echo 0x3d99224  2 > $DCC_PATH/config
    echo 0x3d99270  3 > $DCC_PATH/config
    echo 0x3d99280  2 > $DCC_PATH/config
    echo 0x3d99314  3 > $DCC_PATH/config
    echo 0x3d993a0  3 > $DCC_PATH/config
    echo 0x3d993e4  4 > $DCC_PATH/config
    echo 0x3d9942c  1  > $DCC_PATH/config
    echo 0x3d99470  3 > $DCC_PATH/config
    echo 0x3d99500  12 > $DCC_PATH/config
    echo 0x3d99550  3 > $DCC_PATH/config
    echo 0x3d99560  5 > $DCC_PATH/config
    echo 0x3d99578  2 > $DCC_PATH/config
    echo 0x3d9958c  1  > $DCC_PATH/config
    echo 0x3d995b4  7 > $DCC_PATH/config
    echo 0x3d995d8  1  > $DCC_PATH/config
    echo 0x3d995e0  3 > $DCC_PATH/config
    echo 0x3d9e000  1  > $DCC_PATH/config
    echo 0x3d9e040  5 > $DCC_PATH/config
    echo 0x3d9e080  5 > $DCC_PATH/config
    echo 0x3d9e0a0  3 > $DCC_PATH/config
    echo 0x3d9e0c8  11 > $DCC_PATH/config
    echo 0x3d9e0f8  26 > $DCC_PATH/config
    echo 0x3d9e200  4 > $DCC_PATH/config
    echo 0x3d9f000  2 > $DCC_PATH/config
}

config_clk_gdsc()
{
    echo 0x110018 7 > $DCC_PATH/config
    echo 0x11C018 7 > $DCC_PATH/config
    echo 0x178040 1  > $DCC_PATH/config
    echo 0x199014 7 > $DCC_PATH/config
    echo 0x19D014 7 > $DCC_PATH/config
    echo 0x183004 5 > $DCC_PATH/config
    echo 0x18301C 3 > $DCC_PATH/config
    echo 0x193480 1  > $DCC_PATH/config

}

config_dcc_timer()
{
    echo 0x17421000 2 > $DCC_PATH/config
}

config_dcc_tsens()
{
	#tsens registers
    echo 0x0C222004 1 > $DCC_PATH/config
    echo 0x0C228014 1 > $DCC_PATH/config
    echo 0x0C2280E0 1 > $DCC_PATH/config
    echo 0x0C2280EC 1 > $DCC_PATH/config
    echo 0x0C2280A0 16 > $DCC_PATH/config
    echo 0x0C2280E8 1 > $DCC_PATH/config
    echo 0x0C22813C 1 > $DCC_PATH/config
    echo 0x0C223004 1 > $DCC_PATH/config
    echo 0x0C229014 1 > $DCC_PATH/config
    echo 0x0C2290E0 1 > $DCC_PATH/config
    echo 0x0C2290EC 1 > $DCC_PATH/config
    echo 0x0C2290A0 16 > $DCC_PATH/config
    echo 0x0C2290E8 1 > $DCC_PATH/config
    echo 0x0C22913C 1 > $DCC_PATH/config

    #central broadcast
    echo 0xEC80010 1 > $DCC_PATH/config
    echo 0xEC81000 1 > $DCC_PATH/config
    echo 0xEC81010 16> $DCC_PATH/config
    echo 0xEC81050 16 > $DCC_PATH/config
    echo 0xEC81090 16 > $DCC_PATH/config
    echo 0xEC810D0 16 > $DCC_PATH/config
    echo 0xEC81110 16 > $DCC_PATH/config
    echo 0xEC81550 1 > $DCC_PATH/config

	#Gold LLM
    echo 0x17B70220 6 > $DCC_PATH/config
    echo 0x17B702A0 6 > $DCC_PATH/config
    echo 0x17B70320 1 > $DCC_PATH/config
    echo 0x17B704A0 16 > $DCC_PATH/config
    echo 0x17B70520 1 > $DCC_PATH/config
    echo 0x17B70524 1 > $DCC_PATH/config
    echo 0x17B70588 1 > $DCC_PATH/config
    echo 0x17B70630  2 > $DCC_PATH/config
    echo 0x17B70638  2 > $DCC_PATH/config
    echo 0x17B70640   2 > $DCC_PATH/config
    echo 0x17B71010  24 > $DCC_PATH/config
    echo 0x17B71310   16 > $DCC_PATH/config
    echo 0x17B71390   16 > $DCC_PATH/config
    echo 0x17B72090   8 > $DCC_PATH/config

	#Silver LLM
    echo 0x17B784A0 12 > $DCC_PATH/config
    echo 0x17B78520 1 > $DCC_PATH/config
    echo 0x17B78588 1 > $DCC_PATH/config
    echo 0x17B78630    2 > $DCC_PATH/config
    echo 0x17B78638  2 > $DCC_PATH/config
    echo 0x17B78640   2 > $DCC_PATH/config
    echo 0x17B79010  8 > $DCC_PATH/config
    echo 0x17B79310   6 > $DCC_PATH/config
    echo 0x17B79390  6 > $DCC_PATH/config
    echo 0x17B7A090   4 > $DCC_PATH/config

	#Turing LLM
    echo 0x32310220 4 > $DCC_PATH/config
    echo 0x323102A0 4 > $DCC_PATH/config
    echo 0x323104A0 6 > $DCC_PATH/config
    echo 0x32310520 1 > $DCC_PATH/config
    echo 0x32310588 1 > $DCC_PATH/config
    echo 0x32310630  2 > $DCC_PATH/config
    echo 0x32310638  2 > $DCC_PATH/config
    echo 0x32310640  2 > $DCC_PATH/config
    echo 0x32311010  8 > $DCC_PATH/config
    echo 0x32311310   6 > $DCC_PATH/config
    echo 0x32311390   6 > $DCC_PATH/config
    echo 0x32312090   3 > $DCC_PATH/config
}

enable_dcc()
{
    #TODO: Add DCC configuration
    DCC_PATH="/sys/bus/platform/devices/100ff000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 0 > $DCC_PATH/ap_ns_qad_override_en
    config_dcc_timer
    config_dcc_core
    gemnoc_dump
    gemnoc_dump_full_cxt
    config_dcc_lpm_pcu
    config_dcc_lpm
    config_dcc_ddr
    config_gpu
    config_dcc_timer

    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 0 > $DCC_PATH/ap_ns_qad_override_en
    config_dcc_timer
    mmss_noc_dump
    apss_noc_dump
    system_noc_dump
    aggre_noc_dump
    config_noc_dump
    config_dcc_rpmh
    config_dcc_apss_rscc
    config_dcc_misc
    config_dcc_epss
    config_dcc_turing
    config_dcc_modem
    config_dcc_wpss
    config_dcc_gict
    config_dcc_anoc_pcie
    config_dcc_rng
    config_clk_gdsc
    config_dcc_timer
    echo 3 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 0 > $DCC_PATH/ap_ns_qad_override_en
    config_dcc_timer
    #config_dcc_pcie
    config_dcc_tsens
    config_dc_noc_dump
    lpass_noc_dump
    turing_nsp_noc_dump
    config_dcc_pll_status
    config_dcc_gcc
    config_dcc_phy_tcsr
    config_dcc_timer

    echo 2 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 0 > $DCC_PATH/ap_ns_qad_override_en
    source dcc_extension.sh
    extension
    echo  1 > $DCC_PATH/enable
}

qdss_trace_configure()
{
  echo "configure trace sink settings"
  echo 1 > /sys/bus/coresight/reset_source_sink
  echo mem > /sys/bus/coresight/devices/coresight-tmc-etr/out_mode
  echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/enable_sink
  echo 0x8000000 > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
  ### echo sg > /sys/bus/coresight/devices/coresight-tmc-etr/mem_type
}

stm_traces_configure()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo stm_traces_configure
    echo ++++++++++++++++++++++++++++++++++++++
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
}

stm_traces_start()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo stm_traces_start
    echo ++++++++++++++++++++++++++++++++++++++
    echo 1 > /sys/bus/coresight/devices/coresight-stm/enable_source
}

ipm_traces_configure()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo ipm_traces_configure
    echo ++++++++++++++++++++++++++++++++++++++

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/reset
    echo 0x0 0x3f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x0 0x3f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    # gic HW events
    echo 0xfb 0xfc 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xfb 0xfc 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 1 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 2 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 3 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 4 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 5 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 6 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 7 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 31 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_msr
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_trig_ts
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/reset
    echo 0x0 0x2 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x0 0x2 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0x8a 0x8b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x8a 0x8b 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xb8 0xca 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xb8 0xca 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xf2 0xf5 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xf2 0xf5 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 30 0x00666600  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_trig_ts
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/reset
    echo 0x80 0x81 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_edge_ctrl_mask
    echo 0x80 0x81 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_edge_ctrl
    #  echo 0 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 1 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 2 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 3 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 4 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 5 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 6 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    #  echo 7 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    echo 16 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_msr
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_trig_ts
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/dsb_patt_mask
}

ipm_traces_start()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo ipm_traces_start
    echo ++++++++++++++++++++++++++++++++++++++
    # "Start ipm Trace collection "
    echo 2 > /sys/bus/coresight/devices/coresight-tpdm-apss2/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/enable_source
    echo 2 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/enable_source
    echo 2 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss-apc2/enable_source
}
actpm_traces_configure()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo actpm_traces_configure
    echo ++++++++++++++++++++++++++++++++++++++

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/reset
    echo 0 0x420 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_msr
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/mcmb_lanes_select
    echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_mode
    #echo 1 > /sys/bus/coresight/devices/coresight-tpda-actpm/cmbchan_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_ts_all
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_ts
    echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_mask
    echo 0 0x20000000 > /sys/bus/coresight/devices/coresight-tpdm-actpm/cmb_patt_val
}

actpm_traces_start()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo actpm_traces_start
    echo ++++++++++++++++++++++++++++++++++++++
    # "Start actpm Trace collection "
    echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-actpm/enable_source
}

ftrace_start()
{
    echo ++++++++++++++++++++++++++++++++++++++
    echo ftrace_start
    echo ++++++++++++++++++++++++++++++++++++++

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    echo coresight-stm > /sys/class/stm_source/ftrace/stm_source_link
    echo 1 > /sys/kernel/tracing/tracing_on
}

enable_cpuss_hw_events()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi

    actpm_traces_configure
    ipm_traces_configure
    #stm_traces_configure
    qdss_trace_configure

    ipm_traces_start
    #stm_traces_start
    #ftrace_start
    actpm_traces_start
}

enable_hw_events()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi
    #configure cpuss lpm hw event
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/reset
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/reset
    echo 0x0 0x0 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x0 0x0 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0x1 0x1 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x1 0x1 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0x2 0x2 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x2 0x2 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0x8a 0x8a 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x8a 0x8a 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0x8b 0x8b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0x8b 0x8b 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xb8 0xb8 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xb8 0xb8 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xb9 0xb9 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xb9 0xb9 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xba 0xba 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xba 0xba 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xbb 0xbb 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xbb 0xbb 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xbc 0xbc 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xbc 0xbc 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xbd 0xbd 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xbd 0xbd 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xbe 0xbe 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xbe 0xbe 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xbf 0xbf 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xbf 0xbf 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc0 0xc0 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc0 0xc0 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc1 0xc1 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc1 0xc1 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc2 0xc2 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc2 0xc2 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc3 0xc3 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc3 0xc3 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc4 0xc4 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc4 0xc4 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc5 0xc5 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc5 0xc5 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc6 0xc6 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc6 0xc6 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc7 0xc7 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc7 0xc7 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc8 0xc8 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc8 0xc8 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xc9 0xc9 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xc9 0xc9 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0xca 0xca 0x1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl_mask
    echo 0xca 0xca 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_edge_ctrl
    echo 0 0x00000555  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 17 0x00007700  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 23 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 24 0x00000000  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 25 0x00000500  > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_msr
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_trig_ts
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/dsb_patt_mask
    echo 0x0 0x0 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x0 0x0 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1 0x1 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1 0x1 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2 0x2 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2 0x2 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3 0x3 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3 0x3 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x4 0x4 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x4 0x4 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x5 0x5 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x5 0x5 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x6 0x6 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x6 0x6 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x7 0x7 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x7 0x7 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x8 0x8 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x8 0x8 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x9 0x9 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x9 0x9 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xa 0xa 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xa 0xa 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xb 0xb 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xb 0xb 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xc 0xc 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xc 0xc 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xd 0xd 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xd 0xd 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xe 0xe 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xe 0xe 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xf 0xf 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xf 0xf 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x10 0x10 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x10 0x10 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x11 0x11 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x11 0x11 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x12 0x12 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x12 0x12 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x13 0x13 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x13 0x13 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x14 0x14 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x14 0x14 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x15 0x15 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x15 0x15 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x16 0x16 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x16 0x16 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x17 0x17 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x17 0x17 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x18 0x18 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x18 0x18 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x19 0x19 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x19 0x19 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1a 0x1a 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1a 0x1a 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1b 0x1b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1b 0x1b 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1c 0x1c 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1c 0x1c 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1d 0x1d 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1d 0x1d 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1e 0x1e 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1e 0x1e 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x1f 0x1f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x1f 0x1f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x20 0x20 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x20 0x20 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x21 0x21 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x21 0x21 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x22 0x22 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x22 0x22 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x23 0x23 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x23 0x23 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x24 0x24 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x24 0x24 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x25 0x25 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x25 0x25 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x26 0x26 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x26 0x26 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x27 0x27 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x27 0x27 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x28 0x28 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x28 0x28 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x29 0x29 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x29 0x29 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2a 0x2a 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2a 0x2a 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2b 0x2b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2b 0x2b 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2c 0x2c 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2c 0x2c 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2d 0x2d 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2d 0x2d 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2e 0x2e 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2e 0x2e 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x2f 0x2f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x2f 0x2f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x30 0x30 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x30 0x30 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x31 0x31 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x31 0x31 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x32 0x32 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x32 0x32 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x33 0x33 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x33 0x33 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x34 0x34 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x34 0x34 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x35 0x35 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x35 0x35 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x36 0x36 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x36 0x36 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x37 0x37 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x37 0x37 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x38 0x38 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x38 0x38 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x39 0x39 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x39 0x39 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3a 0x3a 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3a 0x3a 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3b 0x3b 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3b 0x3b 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3c 0x3c 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3c 0x3c 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3d 0x3d 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3d 0x3d 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3e 0x3e 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3e 0x3e 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0x3f 0x3f 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0x3f 0x3f 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xfb 0xfb 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xfb 0xfb 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 0xfc 0xfc 0x1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl_mask
    echo 0xfc 0xfc 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_edge_ctrl
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_ts
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_type
    echo 0 > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_trig_ts
    echo 0 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 1 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 2 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 3 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 4 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 5 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 6 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    echo 7 0xFFFFFFFF > /sys/bus/coresight/devices/coresight-tpdm-apss2/dsb_patt_mask
    #start trace collection
    echo 0x2 > /sys/bus/coresight/devices/coresight-tpdm-apss2/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-apss2/enable_source
    echo 0x2 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/enable_datasets
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-llm-ext/enable_source
}

adjust_permission()
{
    #add permission for block_size, mem_type, mem_size nodes to collect diag over QDSS by ODL
    #application by "oem_2902" group
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/block_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/buffer_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/buffer_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/coresight-tmc-etr/out_mode
    chown -h root.oem_2902 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/block_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/buffer_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/buffer_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/out_mode
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/coresight-tmc-etr1/enable_sink
    chmod 660 /sys/devices/platform/soc/soc:modem_diag/coresight-modem-diag/enable_source
    chown -h root.oem_2902 /sys/bus/coresight/reset_source_sink
    chmod 660 /sys/bus/coresight/reset_source_sink
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo coresight-stm > /sys/class/stm_source/ftrace/stm_source_link
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
}

enable_schedstats()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi

    if [ -f /proc/sys/kernel/sched_schedstats ]
    then
        echo 1 > /proc/sys/kernel/sched_schedstats
    fi
}

enable_cpuss_register()
{
	echo 1 > /sys/bus/platform/devices/soc:mem_dump/register_reset

    echo 0x17000000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17000008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17000054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x170000f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17000100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17008000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100020 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100030 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100084 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100104 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100184 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100204 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100284 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100304 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100384 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100420 0x3a0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100c08 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100d04 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17100e08 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106128 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106138 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106148 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106158 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106160 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106168 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106178 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106180 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106188 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106198 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171061f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106200 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106208 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106220 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106228 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106238 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106250 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106258 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106260 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106268 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106278 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106280 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106288 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106290 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106298 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171062f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106308 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106310 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106318 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106328 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106338 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106340 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106348 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106350 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106358 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106360 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106368 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106378 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106388 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106390 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106398 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171063f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106408 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106418 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106428 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106438 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106440 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106448 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106458 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106460 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106468 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106478 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106480 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106488 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106490 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106498 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171064f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106508 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106510 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106518 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106520 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106528 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106538 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106540 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106548 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106550 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106558 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106560 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106568 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106578 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106580 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106588 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106590 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106598 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171065f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106608 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106610 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106618 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106620 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106628 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106638 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106640 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106648 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106650 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106658 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106660 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106668 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106678 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106680 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106688 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106698 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171066f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106708 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106710 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106718 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106720 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106728 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106738 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106740 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106748 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106750 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106758 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106760 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106768 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106778 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106780 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106788 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106790 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106798 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171067f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106818 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106820 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106828 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106830 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106838 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106840 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106848 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106850 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106858 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106860 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106868 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106870 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106878 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106880 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106888 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106890 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106898 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171068f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106900 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106908 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106910 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106918 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106920 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106928 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106938 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106940 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106948 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106950 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106958 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106960 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106968 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106970 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106978 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106980 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106988 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106990 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106998 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171069f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106a98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106aa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106aa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ab0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ab8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ac0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ac8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ad0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ad8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ae0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ae8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106af0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106af8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106b98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ba0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ba8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106be0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106be8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106bf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106c98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ca0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ca8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ce8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106cf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106d98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106da0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106da8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106db0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106db8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106dc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106dc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106dd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106dd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106de0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106de8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106df0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106df8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106e98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ea0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ea8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106eb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106eb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ec0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ec8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ed0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ed8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ee0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ee8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ef0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ef8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106f98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fe0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106fe8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ff0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17106ff8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107058 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107098 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171070f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107128 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107138 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107148 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107158 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107160 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107168 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107178 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107180 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107188 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107198 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171071f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107200 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107208 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107220 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107228 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107238 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107250 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107258 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107260 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107268 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107278 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107280 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107288 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107290 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107298 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171072f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107308 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107310 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107318 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107328 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107338 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107340 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107348 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107350 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107358 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107360 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107368 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107378 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107388 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107390 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107398 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171073f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107408 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107418 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107428 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107438 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107440 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107448 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107458 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107460 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107468 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107478 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107480 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107488 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107490 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107498 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171074f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107508 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107510 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107518 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107520 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107528 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107538 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107540 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107548 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107550 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107558 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107560 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107568 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107578 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107580 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107588 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107590 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107598 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171075f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107608 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107610 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107618 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107620 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107628 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107638 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107640 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107648 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107650 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107658 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107660 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107668 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107678 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107680 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107688 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107698 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171076f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107708 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107710 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107718 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107720 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107728 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107738 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107740 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107748 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107750 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107758 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107760 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107768 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107778 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107780 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107788 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107790 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107798 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171077f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107818 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107820 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107828 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107830 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107838 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107840 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107848 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107850 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107858 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107860 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107868 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107870 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107878 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107880 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107888 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107890 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107898 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171078f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107900 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107908 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107910 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107918 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107920 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107928 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107938 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107940 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107948 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107950 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107958 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107960 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107968 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107970 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107978 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107980 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107988 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107990 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107998 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171079f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107a98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107aa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107aa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ab0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ab8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ac0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ac8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ad0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ad8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ae0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ae8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107af0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107af8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107b98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ba0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ba8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107be0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107be8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107bf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107c98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ca0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ca8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107ce8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107cf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107d98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107da0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107da8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107db0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107db8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107dc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107dc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107dd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107dd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107de0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107de8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107df0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17107df8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710e008 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710e104 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710e184 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710e204 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ea70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710f000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1710ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17110008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17110fcc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1711ffd0 0x34 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120058 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120098 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171200e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120128 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120148 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120158 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120160 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120168 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120180 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120188 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120198 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171201e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120200 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120208 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120220 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120228 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120250 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120258 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120260 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120268 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120280 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120288 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120290 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120298 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171202e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120308 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120310 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120318 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120328 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120340 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120348 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120350 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120358 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120360 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120368 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120388 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120390 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120398 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171203e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120408 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120418 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120428 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120440 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120448 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120458 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120460 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120468 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120480 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120488 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120490 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120498 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171204e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120508 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120510 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120518 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120520 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120528 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120540 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120548 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120550 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120558 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120560 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120568 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120580 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120588 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120590 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120598 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171205e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120608 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120610 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120618 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120620 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120628 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120640 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120648 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120650 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120658 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120660 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120668 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120680 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120688 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17120698 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171206e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712e000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712e100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712e800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712e808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712ffbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712ffc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1712ffd0 0x44 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130400 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130600 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130a00 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130c40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130c60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130c80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130cc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130e50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130fb8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17130fcc 0x34 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140010 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17140110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1714c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1714c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1714c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1714f000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1714ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17180000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17180014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17180070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17180078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171800c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1718ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17190e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1719f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171a0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171a0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171a0088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171a0120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ac000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ac100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ae100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171c0000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171c0014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171c0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171c0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171c00c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171cffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171d0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171dc180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171df000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171df010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171e0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171e0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171e0088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171e0120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ec000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ec100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x171ee100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17200000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17200014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17200070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17200078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172000c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1720ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17210e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1721f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17220070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17220078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17220088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17220120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1722c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1722c100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1722e100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17240000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17240014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17240070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17240078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172400c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1724ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17250e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1725f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17260070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17260078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17260088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17260120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1726c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1726c100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1726e100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17280000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17280014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17280070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17280078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172800c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1728ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17290e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1729f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172a0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172a0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172a0088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172a0120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ac000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ac100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ae100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172c0000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172c0014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172c0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172c0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172c00c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172cffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172d0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172dc180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172df000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172df010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172e0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172e0078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172e0088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172e0120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ec000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ec100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x172ee100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17300000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17300014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17300070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17300078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173000c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1730ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17310e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1731f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17320070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17320078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17320088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17320120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1732c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1732c100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1732e100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17340000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17340014 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17340070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17340078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173400c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1734ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350400 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350c00 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17350e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735c180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735f000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1735f010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17360070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17360078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17360088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17360120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1736c000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1736c100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1736e100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380020 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380030 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380084 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380104 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380184 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380204 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380284 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380304 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380384 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380420 0x3a0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380c08 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380d04 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17380e08 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386128 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386138 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386148 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386158 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386160 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386168 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386178 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386180 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386188 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386198 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173861f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386200 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386208 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386220 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386228 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386238 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386250 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386258 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386260 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386268 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386278 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386280 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386288 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386290 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386298 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173862f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386308 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386310 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386318 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386328 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386338 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386340 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386348 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386350 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386358 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386360 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386368 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386378 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386388 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386390 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386398 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173863f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386408 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386418 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386428 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386438 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386440 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386448 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386458 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386460 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386468 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386478 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386480 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386488 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386490 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386498 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173864f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386508 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386510 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386518 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386520 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386528 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386538 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386540 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386548 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386550 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386558 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386560 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386568 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386578 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386580 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386588 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386590 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386598 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173865f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386608 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386610 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386618 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386620 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386628 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386638 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386640 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386648 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386650 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386658 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386660 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386668 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386678 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386680 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386688 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386698 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173866f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386708 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386710 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386718 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386720 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386728 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386738 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386740 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386748 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386750 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386758 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386760 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386768 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386778 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386780 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386788 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386790 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386798 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173867f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386818 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386820 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386828 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386830 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386838 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386840 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386848 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386850 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386858 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386860 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386868 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386870 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386878 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386880 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386888 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386890 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386898 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173868f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386900 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386908 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386910 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386918 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386920 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386928 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386938 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386940 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386948 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386950 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386958 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386960 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386968 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386970 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386978 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386980 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386988 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386990 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386998 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173869f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386a98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386aa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386aa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ab0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ab8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ac0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ac8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ad0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ad8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ae0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ae8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386af0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386af8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386b98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ba0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ba8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386be0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386be8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386bf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386c98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ca0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ca8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ce8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386cf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386d98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386da0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386da8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386db0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386db8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386dc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386dc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386dd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386dd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386de0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386de8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386df0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386df8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386e98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ea0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ea8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386eb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386eb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ec0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ec8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ed0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ed8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ee0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ee8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ef0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ef8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386f98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fe0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386fe8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ff0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17386ff8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387058 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387098 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173870f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387128 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387138 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387148 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387158 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387160 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387168 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387178 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387180 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387188 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387198 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173871f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387200 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387208 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387220 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387228 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387238 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387250 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387258 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387260 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387268 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387278 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387280 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387288 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387290 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387298 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173872f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387308 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387310 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387318 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387328 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387338 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387340 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387348 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387350 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387358 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387360 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387368 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387378 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387388 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387390 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387398 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173873f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387408 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387418 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387428 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387438 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387440 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387448 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387458 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387460 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387468 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387478 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387480 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387488 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387490 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387498 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173874f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387508 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387510 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387518 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387520 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387528 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387538 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387540 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387548 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387550 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387558 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387560 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387568 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387578 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387580 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387588 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387590 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387598 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173875f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387608 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387610 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387618 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387620 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387628 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387638 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387640 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387648 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387650 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387658 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387660 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387668 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387678 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387680 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387688 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387698 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173876f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387708 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387710 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387718 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387720 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387728 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387738 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387740 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387748 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387750 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387758 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387760 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387768 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387778 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387780 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387788 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387790 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387798 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173877f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387818 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387820 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387828 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387830 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387838 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387840 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387848 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387850 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387858 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387860 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387868 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387870 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387878 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387880 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387888 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387890 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387898 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173878f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387900 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387908 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387910 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387918 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387920 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387928 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387938 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387940 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387948 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387950 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387958 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387960 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387968 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387970 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387978 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387980 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387988 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387990 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387998 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x173879f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387a98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387aa0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387aa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ab0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ab8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ac0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ac8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ad0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ad8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ae0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ae8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387af0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387af8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387b98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ba0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ba8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387be0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387be8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387bf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387c98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ca0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ca8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cb0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cb8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387ce8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cf0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387cf8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d78 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d80 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d88 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387d98 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387da0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387da8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387db0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387db8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387dc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387dc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387dd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387dd8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387de0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387de8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387df0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17387df8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738e008 0xe8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738e104 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738e184 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738e204 0x74 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea08 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea18 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea28 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea30 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea38 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea40 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea48 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea50 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea58 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea60 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea68 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ea70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738f000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1738ffd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400004 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400038 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400044 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x174000f0 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400200 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400438 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17400444 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17410000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1741000c 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17410020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17411000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1741100c 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17411020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420040 0x1c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420080 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420fc0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420fe0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17420ff0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17421000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17421fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17422000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17422020 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17422fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17423000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17423fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17425000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17425fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17426000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17426020 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17426fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17427000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17427fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17429000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17429fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1742b000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1742bfd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1742d000 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1742dfd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600004 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600010 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600024 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600040 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600080 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600094 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176000d8 0x54 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600134 0x28 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600160 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600170 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600180 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600194 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600210 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600234 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600240 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600274 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176002b4 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600404 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760041c 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600434 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760043c 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600460 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600470 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600480 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600490 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004a0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004b0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004d0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004e0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176004f0 0x50 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600600 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17600614 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176009fc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17601000 0x34 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17602000 0x104 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17603000 0x34 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17604000 0x104 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17605000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17606000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17607000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17608004 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17608020 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17609000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17609008 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17609030 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17609100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17609108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760e014 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760e048 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760e05c 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1760f000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610020 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17610248 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611058 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17611068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613210 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613218 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17613240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17614000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17614100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17614208 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17614304 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17614500 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761500c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615014 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615040 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761504c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615054 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761508c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615094 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176150b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176150c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176150cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176150d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176150f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761510c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615114 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615140 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761514c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615154 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761518c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615194 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176151b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176151c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176151cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176151d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176151f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761520c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615214 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615240 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761524c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615254 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761528c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615294 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176152b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176152c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176152cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176152d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176152f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761530c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615314 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615340 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761534c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615354 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761538c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615394 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176153b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176153c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176153cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176153d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176153f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615400 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761540c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615414 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615440 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761544c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615454 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615480 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761548c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615494 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176154b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176154c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176154cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176154d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176154f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615500 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761550c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615514 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615540 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761554c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615554 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615580 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761558c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615594 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176155b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176155c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176155cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176155d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176155f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615600 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761560c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615614 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615640 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761564c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615654 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615680 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761568c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615694 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176156b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176156c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176156cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176156d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176156f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615700 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761570c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615714 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615740 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761574c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615754 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615780 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761578c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615794 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176157b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176157c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176157cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176157d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176157f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615800 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761580c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615814 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615830 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615840 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761584c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615854 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615870 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615880 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761588c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615894 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176158b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176158c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176158cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176158d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176158f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615900 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761590c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615914 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615940 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761594c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615954 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615970 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615980 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761598c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17615994 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176159b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176159c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176159cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176159d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176159f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17618000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17618100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17618208 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17618304 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17618500 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761900c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619014 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619040 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761904c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619054 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761908c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619094 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176190b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176190c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176190cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176190d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176190f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761910c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619114 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619130 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619140 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761914c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619154 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619170 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619180 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761918c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619194 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176191b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176191c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176191cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176191d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176191f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761920c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619214 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619230 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619240 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761924c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619254 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619270 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619280 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761928c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619294 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176192b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176192c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176192cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176192d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176192f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619300 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761930c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619314 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619330 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619340 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761934c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619354 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619370 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619380 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761938c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619394 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176193b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176193c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176193cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176193d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176193f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619400 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761940c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619414 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619440 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761944c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619454 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619480 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761948c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619494 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176194b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176194c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176194cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176194d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176194f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619500 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761950c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619514 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619530 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619540 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761954c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619554 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619570 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619580 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761958c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619594 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176195b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176195c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176195cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176195d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176195f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619600 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761960c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619614 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619630 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619640 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761964c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619654 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619670 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619680 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761968c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619694 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176196b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176196c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176196cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176196d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176196f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619700 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761970c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619714 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619730 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619740 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761974c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619754 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619770 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619780 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761978c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17619794 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176197b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176197c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176197cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176197d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x176197f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761c000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761c100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761c208 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761c304 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761c500 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d00c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d014 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d040 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d04c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d054 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d080 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d08c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d094 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d0b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d0c0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d0cc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d0d4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1761d0f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17800000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17800008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17800054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178000f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17800100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17810000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17810008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17810054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178100f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17810100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17820000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17820008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17820054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178200f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17820100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17830000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17830008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17830054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178300f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17830100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17840000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17840008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17840054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178400f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17840100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17848000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17850000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17850008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17850054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178500f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17850100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17858000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17860000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17860008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17860054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178600f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17860100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17868000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17870000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17870008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17870054 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178700f0 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17870100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17878000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17880000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17880008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17880068 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178800f0 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17888000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17890000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17890008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17890068 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178900f0 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17898000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178b0008 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178b0054 0x34 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178b0090 0x1dc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178b02a4 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c0000 0x320 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8058 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8078 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8098 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80a8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80b8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80c8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80d0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80e8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c80f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178c8118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178cc000 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178cc030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178cc040 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x178cc090 0x88 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1790000c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900040 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900900 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900c0c 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900c40 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17900fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x1790100c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901040 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901900 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901c0c 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901c40 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17901fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00000 0xd4 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a000d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00100 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00110 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a0011c 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00200 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00224 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00244 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00264 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00284 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a002a4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a002c4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a002e4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00400 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00450 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00490 0x3c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00550 0x200 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00d18 0x19c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00fc0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a00fe8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01018 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01030 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01048 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01060 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01078 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01090 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a010a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a010c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a010d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a010f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01108 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01120 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01138 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01260 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01288 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a012a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a012b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a012d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a012e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01318 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01330 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01348 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01360 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01378 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01390 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a013a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a013c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a013d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a013f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01500 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01528 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01540 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01558 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01570 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01588 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a015a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a015b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a015d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a015e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01600 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01618 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01630 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01648 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01660 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01678 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a01690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10000 0x4c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10050 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a100d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10204 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10224 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10244 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10264 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10284 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a102a4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a102c4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a102e4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10400 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10450 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a104a0 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10550 0x200 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10d18 0x19c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10fc0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a10fe8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11018 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11030 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11048 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11060 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11078 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11090 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a110a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a110c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a110d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a110f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11108 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11120 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11138 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11260 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11288 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a112a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a112b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a112d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a112e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11318 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11330 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11348 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11360 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11378 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11390 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a113a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a113c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a113d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a113f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11500 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11528 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11540 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11558 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11570 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11588 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a115a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a115b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a115d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a115e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11600 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11618 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11630 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11648 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11660 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11678 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a11690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20000 0x4c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20050 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a200d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20204 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20224 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20244 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20264 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20284 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a202a4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a202c4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a202e4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20400 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20450 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a204a0 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20550 0x200 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20d18 0x19c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20fc0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a20fe8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21018 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21030 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21048 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21060 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21078 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21090 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a210a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a210c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a210d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a210f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21108 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21120 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21138 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21260 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21288 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a212a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a212b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a212d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a212e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21318 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21330 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21348 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21360 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21378 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21390 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a213a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a213c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a213d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a213f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21500 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21528 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21540 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21558 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21570 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21588 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a215a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a215b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a215d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a215e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21600 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21618 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21630 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21648 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21660 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21678 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21690 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a217a0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a217c8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a217e0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a217f8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21810 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21828 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21840 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21858 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21870 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21888 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a218a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a218b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a218d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a218e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21900 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21918 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21930 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21a40 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21a68 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21a80 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21a98 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ab0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ac8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ae0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21af8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b10 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b28 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b40 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b58 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b70 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21b88 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ba0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21bb8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21bd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ce0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d08 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d20 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d38 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d50 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d68 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d80 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21d98 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21db0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21dc8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21de0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21df8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21e10 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21e28 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21e40 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21e58 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21e70 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21f80 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21fa8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21fc0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21fd8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a21ff0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22008 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22020 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22038 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22050 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22068 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22080 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22098 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a220b0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a220c8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a220e0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a220f8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a22110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30000 0x4c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30050 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a300d8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30204 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30224 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30244 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30264 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30284 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a302a4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a302c4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a302e4 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30400 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30450 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a304a0 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30550 0x200 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30d00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30d10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30d18 0x19c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30fc0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a30fe8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31000 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31018 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31030 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31048 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31060 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31078 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31090 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a310a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a310c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a310d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a310f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31108 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31120 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31138 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31150 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31260 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31288 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a312a0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a312b8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a312d0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a312e8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31318 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31330 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31348 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31360 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31378 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a31390 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a313a8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a313c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a313d8 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a313f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a80000 0x44 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a82000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a83000 0x400 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a84000 0x44 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a86000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a87000 0x400 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a88000 0x44 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a8a000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a8b000 0x400 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a8c000 0x44 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a8e000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a8f000 0x400 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a90000 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a90080 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a900cc 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a900e4 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a900f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a900f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a90118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a92000 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a92080 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a920cc 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a920e4 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a920f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a920f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a92118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a94000 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a94080 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a940cc 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a940e4 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a940f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a940f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a94118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a96000 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a96080 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a960cc 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a960e4 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a960f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a960f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17a96118 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0000 0xb0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa00bc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa00fc 0x50 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0200 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0300 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17aa0700 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b00000 0x120 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70010 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b700a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b700c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70110 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b701a0 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70220 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b702a0 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70390 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70420 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b704a0 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70520 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70580 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70610 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70680 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70710 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70790 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70810 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70890 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70910 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70990 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70a10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70a90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70b10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70b90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70c10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70c90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70d10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70d90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70e10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70e90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70f10 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b70f90 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71010 0x60 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71090 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71110 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71190 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71210 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71290 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71310 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71390 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71410 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71490 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71510 0x200 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71d10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71d90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71e10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71e90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71f10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b71f90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72010 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72090 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72110 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b721a0 0x1c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b721c0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72250 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b722e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b722f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b723a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b723c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b723e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b723f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b72490 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78010 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78090 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b780a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b780c0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78110 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b781a0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78220 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b782a0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78390 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78420 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b784a0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78520 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78580 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78600 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78610 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78680 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78710 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78790 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78810 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78890 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78910 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78990 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78a10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78a90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78b10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78b90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78c10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78c90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78d10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78d90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78e10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78e90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78f10 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b78f90 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79010 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79090 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79110 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79190 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79210 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79290 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79310 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79390 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79400 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79410 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79490 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79510 0x100 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79d10 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79d90 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79e10 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79e90 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79f10 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b79f90 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a010 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a090 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a100 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a110 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a190 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a1a0 0x1c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a1c0 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a240 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a250 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a2e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a2f0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a380 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a3a0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a3c0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a3e0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a3f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a410 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a470 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b7a490 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90020 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90080 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90200 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b9070c 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b9077c 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90808 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90824 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90840 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90c48 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90c64 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b90c80 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b92000 0x148 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93000 0x140 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93500 0x140 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93a00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93a24 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93a2c 0xc4 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b20 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b30 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b64 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b70 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17b93c00 0x98 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0000 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0020 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0070 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0080 0x64 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0120 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0140 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0200 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0700 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba070c 0x48 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba077c 0x84 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0808 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0824 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0840 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0c48 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0c64 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba0c80 0x40 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba2000 0x148 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3000 0x140 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3500 0x140 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3a00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3a24 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3a2c 0xc4 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b20 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b30 0x2c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b64 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b70 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3b90 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ba3c00 0x98 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17c20000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17c21000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10000 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10200 0x400 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10700 0x9c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10800 0x11c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10920 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d10a00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d30000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d34000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d3bff8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d40028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50000 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50040 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50138 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50178 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d50e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90014 0x68 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90080 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d900b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d900b8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d900d0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90100 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90200 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d9034c 0x7c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d903e0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90404 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d90470 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91014 0x68 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91080 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d910b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d910b8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d910d0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91100 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91200 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91320 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d9134c 0x8c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d913e0 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91404 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91430 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91450 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d91470 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92014 0x68 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92080 0x1c > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d920b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d920b8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d920d0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92100 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92200 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92320 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d9234c 0x88 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d923e0 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92404 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92430 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92450 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d92470 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93000 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93014 0x68 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93080 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d930b0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d930b8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d930d0 0x24 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93100 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93200 0xa0 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93300 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93320 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d9334c 0x80 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d933e0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93404 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93420 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93430 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93450 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d93470 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17d98000 0x68 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00048 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00050 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00060 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00068 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00080 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e00088 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10040 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e100f0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e100f8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e10500 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e11000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e20fd0 0x30 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e30fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40400 0x14 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40c00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40c20 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40fc8 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e40fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e80fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17e90fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ea0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17eb0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17eb0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17ec0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f80fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17f90fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fa0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fb0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x17fb0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18080fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18090fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x180c0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18180fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18190fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x181b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18280fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18290fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x182b0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18380fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18390fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x183b0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18480fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18490fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x184b0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580000 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580010 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580030 0x18 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580050 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580170 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580fb0 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18580fc8 0x38 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590100 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590108 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590110 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590400 0x10 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590480 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590c00 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590c20 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590ce0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590e00 0xc > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590fa8 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590fcc 0x8 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x18590fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0008 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0018 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0028 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0030 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0038 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0800 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0808 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0810 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0e00 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0e10 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0fa8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0fbc 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0fc8 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0fd0 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185a0fe0 0x20 > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185b0000 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185b0010 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config
    echo 0x185b0020 0x4  > /sys/bus/platform/devices/soc:mem_dump/register_config

    #EPSS PDMEM region
    echo 0x17D00000 0x10000 > /sys/bus/platform/devices/soc:mem_dump/register_config
}

enable_buses_and_interconnect_tracefs_debug()
{
    tracefs=/sys/kernel/tracing

    # enable tracing for consolidate/debug builds, where debug_build is set true
    if [ "$debug_build" = true ]
    then
        setprop persist.vendor.tracing.enabled 1
    fi

    if [ -d $tracefs ] && [ "$(getprop persist.vendor.tracing.enabled)" -eq "1" ]; then
        mkdir $tracefs/instances/hsuart
        #UART
        echo 800 > $tracefs/instances/hsuart/buffer_size_kb
        echo 1 > $tracefs/instances/hsuart/events/serial/enable
        echo 1 > $tracefs/instances/hsuart/tracing_on

        #SPI
        mkdir $tracefs/instances/spi_qup
        echo 20 > $tracefs/instances/spi_qup/buffer_size_kb
        echo 1 > $tracefs/instances/spi_qup/events/qup_spi_trace/enable
        echo 1 > $tracefs/instances/spi_qup/tracing_on

        #I2C
        mkdir $tracefs/instances/i2c_qup
        echo 20 > $tracefs/instances/i2c_qup/buffer_size_kb
        echo 1 > $tracefs/instances/i2c_qup/events/qup_i2c_trace/enable
        echo 1 > $tracefs/instances/i2c_qup/tracing_on

        #SLIMBUS
        mkdir $tracefs/instances/slimbus
        echo 1 > $tracefs/instances/slimbus/events/slimbus/slimbus_dbg/enable
        echo 1 > $tracefs/instances/slimbus/tracing_on

        #CLOCK, REGULATOR, INTERCONNECT, RPMH
        mkdir $tracefs/instances/clock_reg
        echo 1 > $tracefs/instances/clock_reg/events/clk/enable
        echo 1 > $tracefs/instances/clock_reg/events/regulator/enable
        echo 1 > $tracefs/instances/clock_reg/events/interconnect/enable
        echo 1 > $tracefs/instances/clock_reg/events/rpmh/enable
        echo 1 > $tracefs/instances/clock_reg/tracing_on
    fi
}

create_stp_policy()
{
    mkdir /config/stp-policy/coresight-stm:p_ost.policy
    chmod 660 /config/stp-policy/coresight-stm:p_ost.policy
    mkdir /config/stp-policy/coresight-stm:p_ost.policy/default
    chmod 660 /config/stp-policy/coresight-stm:p_ost.policy/default
    echo 0x10 > /sys/bus/coresight/devices/coresight-stm/traceid
}

#function to enable cti flush for etf
enable_cti_flush_for_etf()
{
    # bail out if its perf config
    if [ "$debug_build" = false ]
    then
        return
    fi

    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etf/stop_on_flush
    echo 1 >/sys/bus/coresight/devices/coresight-cti-swao_cti/enable
    echo 0 24 >/sys/bus/coresight/devices/coresight-cti-swao_cti/channels/trigin_attach
    echo 0 1 >/sys/bus/coresight/devices/coresight-cti-swao_cti/channels/trigout_attach
}

find_build_type()
{
    linux_banner=`cat /proc/version`
    if [[ "$linux_banner" == *"-consolidate"* ]]
    then
        debug_build=true
    fi
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
debug_build=false
srcenable="enable"
enable_debug()
{
    echo "volcano debug"
    etr_size="0x2000000"
    srcenable="enable_source"
    sinkenable="enable_sink"
    find_build_type
    create_stp_policy
    adjust_permission
    enable_stm_events
    enable_cti_flush_for_etf
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing
        enable_buses_and_interconnect_tracefs_debug
    fi
    enable_dcc
    #enable_cpuss_hw_events
    #enable_hw_events
    enable_schedstats
    enable_cpuss_register
    sf_tracing_disablement
}

enable_debug
