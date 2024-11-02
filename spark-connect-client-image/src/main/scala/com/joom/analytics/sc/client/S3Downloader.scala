package com.joom.analytics.sc.client

import com.amazonaws.regions.Regions
import com.amazonaws.services.s3.AmazonS3ClientBuilder
import com.amazonaws.services.s3.model.GetObjectRequest

import java.io.File

object S3Downloader {

  def main(args: Array[String]): Unit = {
    val sourceS3Uri = args(0)
    val targetLocalPath = args(1)

    assert(sourceS3Uri.startsWith("s3://"), "sourceS3Uri must contain S3 uri")
    val s3Parts = sourceS3Uri.drop(5).split("/", 2)
    val bucket = s3Parts(0)
    val key = s3Parts(1)

    val s3client = AmazonS3ClientBuilder.standard()
      .withRegion(Regions.EU_CENTRAL_1)
      .build()
    s3client.getObject(new GetObjectRequest(bucket, key), new File(targetLocalPath))
  }
}
