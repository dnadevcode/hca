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

## Tutorial

### How to Generate Theory Using GUI Buttons:

1. **Launch the HCA Barcode Alignment Tool**: Open the HCA Barcode Alignment tool by running the provided MATLAB function. You can do this by clicking on its icon or executing the function from the MATLAB command window.

2. **Navigate Through the Menu**:
   - **Theory Menu**: Once the tool is launched, you'll see a menu labeled "HCA". Click on it to reveal options related to HCA (Hierarchical Cluster Analysis).
   - **Theory Submenu**: Under the HCA menu, locate the "Theory" submenu and click on it. This submenu contains options related to theory generation.
  
3. **Select Theory Generation Option**:
   - In the Theory submenu, you'll find options like "Generate theory" and "Concatenate theories".
   - Click on "Generate theory" to initiate the process of generating theory from your data.

4. **Provide Necessary Inputs**:
   - Depending on the GUI setup, you may need to provide inputs such as file paths or settings related to theory generation. These inputs are typically provided through the GUI elements that appear on the screen.

5. **Run Theory Generation**:
   - After providing the necessary inputs, click on the "Run" button or similar action button to start the theory generation process.

6. **Monitor Progress**:
   - As the theory generation process runs, the GUI may display progress indicators or messages to keep you informed about the ongoing operations.

7. **Review Results**:
   - Once the theory generation is complete, you may have the option to review the results directly within the GUI interface. This could include visualizations or summaries of the generated theories.

8. **Save Generated Theory (Optional)**:
   - Depending on your workflow, you might have the option to save the generated theory for future reference or analysis. If prompted or provided with an option, specify a location and filename to save the theory data.

9. **Explore Further Options**:
   - Feel free to explore other options or functionalities available in the HCA Barcode Alignment tool. You can navigate through different menus and submenus to access various features for data analysis and manipulation.

### Note:
- Ensure that you have the necessary permissions and access to the data files required for theory generation.
- Follow any specific instructions or guidelines provided within the GUI interface for a smooth theory generation process.
- In case of any issues or questions, refer to the documentation or seek assistance from someone familiar with using the HCA Barcode Alignment tool in MATLAB.


### How to Concatenate Theories:

1. **Click the "Concatenate theories" Button**: Locate and click on the "Concatenate theories" button in your MATLAB user interface.

2. **Select Files**: After clicking the button, a dialog box will appear prompting you to select one or more files. These files should contain theory data that you want to merge together.

3. **Wait for Processing**: Once you've selected the files, the function will start processing them. This may take a moment depending on the size and number of files.

4. **Review Messages**: As the function runs, it will display messages in the MATLAB command window. If all selected files have compatible settings, the function will concatenate the theories. If there are any issues, such as incompatible settings between files, the function will inform you about them.

5. **Save Concatenated Data**: If the function successfully merges the theories, it will prompt you to save the concatenated data. Choose a location and filename for the new file.

6. **Done!**: Once the data is saved, the function will confirm the successful concatenation. You can then access the merged theory data from the file you saved it to.
