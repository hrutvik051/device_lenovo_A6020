#!/system/vendor/bin/sh
# Copyright (c) 2012-2015, The Linux Foundation. All rights reserved.
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
#

target=`getprop ro.board.platform`

case "$target" in
    "msm8916")

        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
        echo 81250 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

        # HMP scheduler settings for 8929, 8939
        echo 3 > /proc/sys/kernel/sched_window_stats_policy
        echo 9 > /proc/sys/kernel/sched_upmigrate_min_nice

        # Apply governor settings for 8939
        case "$soc_id" in
            "239" | "241" | "263" | "268" | "269" | "270" | "271")

            if [ `cat /sys/devices/soc0/revision` != "3.0" ]; then
                # Apply 1.0 and 2.0 specific Sched & Governor settings

                # HMP scheduler load tracking settings
                echo 5 > /proc/sys/kernel/sched_ravg_hist_size

                # HMP Task packing settings for 8939, 8929
                echo 20 > /proc/sys/kernel/sched_small_task

        for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
        do
            echo "cpufreq" > $devfreq_gov
        done

        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
        do
             echo "bw_hwmon" > $devfreq_gov
                         for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
                         do
                                echo 20 > $cpu_io_percent
                         done
        done

        for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
        do
             echo 40 > $gpu_bimc_io_percent
        done

            # disable core control to update interactive gov settings
            echo 0 > /sys/module/msm_thermal/core_control/enabled
            echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/disable
            echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/disable

            # enable governor for perf cluster
            echo 1 > /sys/devices/system/cpu/cpu0/online
            echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
            echo "60000 400000:10000 533333:70000 800000:80000 960000:90000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
            echo 98 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
            echo 60000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
            echo 1363200 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
            echo 480000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
            echo "90 200000:75 345600:80 400000:83 533333:86 800000:90 960000:94 1113600:98 1363200:100" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
            echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/powersave_bias

            # enable governor for power cluster
            echo 1 > /sys/devices/system/cpu/cpu4/online
            echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
            echo 95 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
            echo 60000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
            echo 480000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
            echo 998400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
            echo "90 200000:75 249600:80 499200:85 800000:90 998400:95 1113600:100" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
            echo 200000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/powersave_bias

            # enable core_control now
            echo 1 > /sys/module/msm_thermal/core_control/enabled
            echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/disable
            echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
            echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
            echo "1 1 0 0" > /sys/devices/system/cpu/cpu0/core_ctl/always_online_cpu
            echo 40 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
            echo 25 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
            echo 1000 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
            echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
            echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
            echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/disable
            echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
            echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
            echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
            echo 15 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
            echo 5000 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
            echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/not_preferred

            # Bring up all cores online
            echo 1 > /sys/devices/system/cpu/cpu1/online
            echo 1 > /sys/devices/system/cpu/cpu2/online
            echo 1 > /sys/devices/system/cpu/cpu3/online
            echo 1 > /sys/devices/system/cpu/cpu4/online
            echo 1 > /sys/devices/system/cpu/cpu5/online
            echo 1 > /sys/devices/system/cpu/cpu6/online
            echo 1 > /sys/devices/system/cpu/cpu7/online

            # Enable low power modes
            echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

            # HMP scheduler (big.Little cluster related) settings
            echo 70 > /proc/sys/kernel/sched_upmigrate
            echo 60 > /proc/sys/kernel/sched_downmigrate

            # cpu idle load threshold
            echo 30 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_load
            echo 30 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_load

            # cpu idle nr run threshold
            echo 3 > /sys/devices/system/cpu/cpu0/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu1/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu2/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu3/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu4/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu5/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu6/sched_mostly_idle_nr_run
            echo 3 > /sys/devices/system/cpu/cpu7/sched_mostly_idle_nr_run

        else
            # Apply 3.0 specific Sched & Governor settings
            # HMP scheduler settings for 8939 V3.0
            echo 3 > /proc/sys/kernel/sched_window_stats_policy
            echo 3 > /proc/sys/kernel/sched_ravg_hist_size
            echo 20000000 > /proc/sys/kernel/sched_ravg_window

            # HMP Task packing settings for 8939 V3.0
            echo 20 > /proc/sys/kernel/sched_small_task
            echo 30 > /proc/sys/kernel/sched_mostly_idle_load
            echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run

            echo 0 > /sys/devices/system/cpu/cpu0/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu1/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu2/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu3/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu4/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu5/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu6/sched_prefer_idle
            echo 0 > /sys/devices/system/cpu/cpu7/sched_prefer_idle

        for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
        do
            echo "cpufreq" > $devfreq_gov
        done

        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
        do
            echo "bw_hwmon" > $devfreq_gov
            for cpu_io_percent in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/io_percent
            do
                echo 20 > $cpu_io_percent
            done
        done

        for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
        do
            echo 40 > $gpu_bimc_io_percent
        done
            # disable thermal core_control to update interactive gov settings
            echo 0 > /sys/module/msm_thermal/core_control/enabled

            # enable governor for perf cluster
            echo 1 > /sys/devices/system/cpu/cpu0/online
            echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
            echo "60000 400000:10000 533333:70000 800000:80000 960000:85000 1113600:90000 1344000:95000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
            echo 95 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
            echo 60000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
            echo 1497600 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
            echo 480000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
            echo "90 200000:70 345600:75 400000:79 533333:83 800000:86 960000:90 1113600:92 1344000:95 1497600:99" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
            echo 200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
            echo 1497600 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
            echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/powersave_bias

            # enable governor for power cluster
            echo 1 > /sys/devices/system/cpu/cpu4/online
            echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
            echo "0 998400:20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
            echo 97 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
            echo 60000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
            echo 480000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
            echo 1113600 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
            echo "72 200000:73 249600:75 499200:85 800000:90 998400:93 1113600:97 1209600:100" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
            echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/powersave_bias

            # enable thermal core_control now
            echo 1 > /sys/module/msm_thermal/core_control/enabled

            # enable core control
            echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
            echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
            echo "1 0 0 0" > /sys/devices/system/cpu/cpu0/core_ctl/always_online_cpu
            echo 50 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
            echo 30 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
            echo 1000 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
            echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
            echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
            echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
            echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
            echo 35 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
            echo 20 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
            echo 5000 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
            echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/not_preferred

            # Bring up all cores online
            echo 1 > /sys/devices/system/cpu/cpu1/online
            echo 1 > /sys/devices/system/cpu/cpu2/online
            echo 1 > /sys/devices/system/cpu/cpu3/online
            echo 1 > /sys/devices/system/cpu/cpu5/online
            echo 1 > /sys/devices/system/cpu/cpu6/online
            echo 1 > /sys/devices/system/cpu/cpu7/online

            # Enable low power modes
            echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

            # HMP scheduler (big.Little cluster related) settings
            echo 90 > /proc/sys/kernel/sched_upmigrate
            echo 75 > /proc/sys/kernel/sched_downmigrate
            echo 0 > /proc/sys/kernel/sched_boost

            # Enable sched guided freq control
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
            echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
            echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
            echo 50000 > /proc/sys/kernel/sched_freq_inc_notify
            echo 50000 > /proc/sys/kernel/sched_freq_dec_notify

                case "$revision" in
                     "3.0")
                     # Enable dynamic clock gating
                    echo 1 > /sys/module/lpm_levels/lpm_workarounds/dynamic_clock_gating
                ;;
                esac
            fi

            # Limit min frequency to 200MHz in msm_performance
            echo "0:200000 4:200000" > /sys/module/msm_performance/parameters/cpu_min_freq

            ;;
        esac
    ;;
esac
