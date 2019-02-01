
set project_name  "system"
set synth_task    "synth_1"
set impl_task     "impl_1"
set timing_report "timing_1"

open_project "$project_name.xpr"

# run synthesis
launch_runs $synth_task
wait_on_run -verbose $synth_task

# run implementation
launch_runs $impl_task
wait_on_run -verbose $impl_task

# write bitstream
open_run $impl_task -name $impl_task
write_bitstream "$project_name.bit"
