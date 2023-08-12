/**
 * This function set the cache-control headers
 * and error responses for failed user requests
 */

import "source-map-support/register"
import { CloudFrontResponseEvent, CloudFrontResponse } from "aws-lambda"
import axios from "axios"
import * as https from "https"

const cacheKey = process.env.PRERENDER_CACHE_KEY || "x-prerender-requestid"
const cacheMaxAge = process.env.PRERENDER_CACHE_MAX_AGE || 10
const errorPageUrl = process.env.ERROR_PAGE || "https://blog.bizkt.com.au/404.html"

// Create axios client outside of lambda function for re-use between calls
const instance = axios.create({
  timeout: 1000,
  // Don't follow redirects
  maxRedirects: 0,
  // Only valid response codes are 200
  validateStatus: function (status) {
    return status == 200
  },
  // keep connection alive so we don't constantly do SSL negotiation
  httpsAgent: new https.Agent({ keepAlive: true }),
})

export const handler = async (event: CloudFrontResponseEvent): Promise<CloudFrontResponse> => {
  const response = event.Records[0].cf.response

  /**
   * If the x-prerender-requestid header is present
   * set the cache-control headers
   * This is to prevent prerender.io from caching the response
   */
  if (response.headers[`${cacheKey}`]) {
    response.headers["Cache-Control"] = [
      {
        key: "Cache-Control",
        value: `max-age=${cacheMaxAge}`,
      },
    ]
  } else if (response.status != "200") {
    return instance
      .get(errorPageUrl)
      .then((res) => {
        response.body = res.data
        response.headers["content-type"] = [
          {
            key: "Content-Type",
            value: "text/html",
          },
        ]

        // Remove content-length if set as this may be the value from the origin.
        delete response.headers["content-length"]

        return response
      })
      .catch(() => {
        return response
      })
  }
  return response
}
