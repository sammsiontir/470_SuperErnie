#!/bin/bash

# Setup your configuration variables

assemble=./vs-asm
copy=cp

# Build a fresh simv
echo "> Building simv..."
make_out=$(make simv 2>&1)
# Redirect stdout->stderr and capture
# both in the variable make_out
if [ $? -ne 0 ]; then
  # if make fails...
  echo "> Building simv failed!"
  echo "$make_out"
  # These quotes are important to
  # preserve whitespace in the output
fi
echo "> simv is built"

# Run all the test cases
echo "> Running regressions..."
for file in `ls test_progs`;
do 
  file=$(echo $file | cut -d'.' -f1);
  $assemble ./test_progs/$file.s > ./test_mems/$file.mem;
  $copy ./test_mems/$file.mem ./program.mem
  simv_out=$(./simv | tee program.out 2>&1)
  $copy writeback.out ./log/$file.writeback.out; 
  $copy program.out ./log/$file.program.out; 
  $copy out ./time/$file;
done
echo "> Finished running regressions."


# Validate their output
echo "> Comparing the results..."
for file in `ls test_progs`;
do
  file=$(echo $file | cut -d'.' -f1);
  write_diff_out=$(diff ./log/$file.writeback.out ./log/$file.writeback.gold.out > ./diff/$file.writeback.diff)
  program_diff_out=$(diff -u <(grep -E '@@@' ./log/$file.program.out) <(grep -E '@@@' ./log/$file.program.gold.out) > ./diff/$file.program.diff)
done

for file in `ls test_progs`;
do
  file=$(echo $file | cut -d'.' -f1);
  if [ -s ./diff/$file.wirteback.diff ] || [ -s ./diff/$file.program.diff ]; then
    printf "%20s:\e[0;31mFAILED\e[0m\n" "$file"
  else
    printf "%20s:\e[0;32mPASSED\e[0m\n" "$file"
  fi
done
echo "> Finished."

# Print the results!
