package com.omnidapps.innoflow

import com.nt4f04und.android_content_provider.AndroidContentProvider

class WorkflowContentProvider : AndroidContentProvider() {
   override val authority: String = "com.omnidapps.innoflow.WorkflowContentProvider"
   override val entrypointName = "workflowContentProviderEntrypoint"
}