# HCA

Separate project folder for the HCA (Human Chromosome Analysis) and Bacterial chromosome analysis tool


# Structure

- src/+CBT/+HCA   	Code developed specifically for this project 
- bin/			Other code imported from different projects

- documentation/	Documentation
- data/			Data

# How to run:
matlab
addpath(genpath(pwd));

# GUI (NEW)
hca_barcode_alignment

# GUI'S (OLD):
Hca_theory - theory
Hca_gui - experiments
Hca_run - same as gui but allows adding consensus and p-val calc
# /src/Scripts/ has a number of test scripts

## Test
results = runtests('pcc_compute_test.m') - other tests will be included in later versions



### How to Concatenate Theories:

1. **Click the "Concatenate theories" Button**: Locate and click on the "Concatenate theories" button in your MATLAB user interface.

2. **Select Files**: After clicking the button, a dialog box will appear prompting you to select one or more files. These files should contain theory data that you want to merge together.

3. **Wait for Processing**: Once you've selected the files, the function will start processing them. This may take a moment depending on the size and number of files.

4. **Review Messages**: As the function runs, it will display messages in the MATLAB command window. If all selected files have compatible settings, the function will concatenate the theories. If there are any issues, such as incompatible settings between files, the function will inform you about them.

5. **Save Concatenated Data**: If the function successfully merges the theories, it will prompt you to save the concatenated data. Choose a location and filename for the new file.

6. **Done!**: Once the data is saved, the function will confirm the successful concatenation. You can then access the merged theory data from the file you saved it to.
