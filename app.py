import streamlit as st
import matlab.engine
import tempfile
import os
from PIL import Image


# Define the project folder 
project_folder = os.path.join(os.getcwd(), 'your_project_folder')


st.title("Basic Spectrum Analysis App")

uploaded_file = st.file_uploader("Upload audio", type=["wav", "mp3", "flac"])

if uploaded_file:
    with tempfile.TemporaryDirectory() as tmpdir:
        input_path = os.path.join(tmpdir, uploaded_file.name)
        with open(input_path, "wb") as f:
            f.write(uploaded_file.read())

        # Start MATLAB and add the function directory
        eng = matlab.engine.start_matlab()
        eng.addpath(project_folder, nargout=0)

        # Call MATLAB function
        output_path = eng.generate_spectrogram(input_path, tmpdir, nargout=1)
        eng.quit()

        # Display the result
        st.image(output_path, caption="Spectrogram", use_column_width=True)
