#!/bin/bash

# Define classpath including JUnit and Hamcrest jars
CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
EXPECTED_FILENAME="ListExamples.java"

# Function to clean up before exit
cleanup() {
    echo "Cleaning up..."
    rm -rf student-submission
    rm -rf grading-area
}

# Check if the repository URL is provided
if [ $# -eq 0 ]; then
    echo "Error: No repository URL provided."
    exit 1
fi

# Setup grading area
cleanup
mkdir grading-area

# Clone the student's repository
git clone "$1" student-submission
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone repository."
    exit 1
fi
echo 'Finished cloning'

# Check if the expected file is present in the submission
if [ ! -f "student-submission/$EXPECTED_FILENAME" ]; then
    echo "Error: Expected file $EXPECTED_FILENAME not found in the submission."
    cleanup
    exit 1
fi

# Copy the student's submission and the test files to the grading area
cp student-submission/$EXPECTED_FILENAME grading-area/
cp YourTestFile.java grading-area/ # Replace with your actual test file

# Navigate to the grading area
cd grading-area

# Compile the student code and the test files
javac -cp "$CPATH" *.java
if [ $? -ne 0 ]; then
    echo "Error: Compilation failed."
    cleanup
    exit 1
else
    echo "Compilation successful."
fi

# Run the tests
java -cp "$CPATH" org.junit.runner.JUnitCore [YourTestClassName]
if [ $? -eq 0 ]; then
    echo "All tests passed."
    # You can add additional logic to calculate the score
else
    echo "Some tests failed."
    # You can add additional logic to extract which tests failed and provide feedback
fi

# Clean up and return to the original directory
cd ..
cleanup