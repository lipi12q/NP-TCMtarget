# NP-TCMtarget
NP-TCMtarget: a network pharmacology platform for exploring mechanisms of action of Traditional Chinese medicine
---------------------------
NP-TCMtarget is a network pharmacology platform for exploring mechanisms of action of TCM at the molecular target level. The core conception of NP-TCMtarget is to untangle the intricate relationship between TCM drugs and targets, identify direct targets that directly bind with TCM components to produce biological effects and indirect targets that mediate the effects of direct targets in the biological molecular network, and finally explore the path of “herbal components-direct targets-indirect targets-biological effects”.

<img src="https://github.com/lipi12q/NP-TCMtarget/blob/main/www/Figure2.jpg" width = "550px" height = "auto">

Installation
-----------------------------
### Create and activate Python environment
for NP-TCMtarget, the python version need is over 3.8. if you have installed Python3.6 or Python3.7, consider installing Anaconda , and then you can create a new environment.
```
conda create -n NP-TCMtarget python=3.8
conda activate NP-TCMtarget
```
### Install DeepPurpose
```
conda install -c conda-forge rdkit
pip install git+https://github.com/bp-kelley/descriptastorus 
pip install DeepPurpose
```
### The R package is available on CRAN
```
install.packages("shiny")
install.packages("shinydashboard")
install.packages("dplyr")
install.packages("reticulate")
install.packages("WebGestaltR")
```
Getting Started
----------------
To facilitate quick and easy use of NP-TCMtarget, we have developed an online platform available at http://www.bcxnfz.top/NP-TCMtarget/. During the operation process, please be sure to refer to the User Guide, which will guide you on how to upload the appropriate files, ensuring that you can make full use of the powerful capabilities of NP-TCMtarget."

Of course, you also have the option to download NP-TCMtarget for local execution. If you choose this route, ensure that any necessary software dependencies, such as specific versions of R and Python libraries, are installed in their respective environments. Specifically, if you're using R with a Conda environment named NP-TCMtarget, make sure that the R session is properly linked to this environment so it can access the Python tools within it. Once the setup is complete, you can run the 'app.R' file to launch the NP-TCMtarget application interface, and follow the user guide ('User Guide') to upload the required files.



