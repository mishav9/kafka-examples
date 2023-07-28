#!/bin/bash

# Replace with your actual GCP project ID
PROJECT_ID="your-project-id"

# Replace with the ID of your Dataflow job
JOB_ID="your-dataflow-job-id"

# Function to check the status of the Dataflow job
function check_job_status() {
    gcloud dataflow jobs describe "${JOB_ID}" --project="${PROJECT_ID}" --format='value(STATUS.state)'
}

# Function to drain the Dataflow job
function drain_dataflow_job() {
    gcloud dataflow jobs drain "${JOB_ID}" --project="${PROJECT_ID}"
}

# Check the status of the Dataflow job
job_status=$(check_job_status)

# Check if the job is running
if [[ "${job_status}" == "JOB_STATE_RUNNING" ]]; then
    echo "Dataflow job is running. Draining the job..."
    # Drain the Dataflow job
    drain_dataflow_job

    # Wait until the job is drained
    while true; do
        job_status=$(check_job_status)
        echo "Job status: ${job_status}"

        # Check if the job is in a terminal state (DONE, FAILED, CANCELLED)
        if [[ "${job_status}" == "JOB_STATE_DONE" || "${job_status}" == "JOB_STATE_FAILED" || "${job_status}" == "JOB_STATE_CANCELLED" ]]; then
            echo "Dataflow job has been successfully drained."
            break
        fi

        # Wait for 10 seconds before checking the status again
        sleep 10
    done
else
    echo "Dataflow job is not running."
fi
