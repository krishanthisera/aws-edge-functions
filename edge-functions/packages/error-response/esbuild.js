import { build } from "esbuild"
import fg from "fast-glob"
import "dotenv/config"

/**
 * If the ENV is not set
 * The build will be interrupted
 */
const define = {
  "process.env.FRONTEND_HOST": `"${process.env.FRONTEND_HOST}"`,
}

// For optional ENVs
for (const k in process.env) {
  define[`process.env.${k}`] = JSON.stringify(process.env[k])
}

export const buildNode = async ({ ...args }) => {
  await build({
    entryPoints: await fg("src/*.ts"),
    platform: "node",
    target: "node16",
    format: "cjs",
    outdir: "./build",
    sourcemap: false,
    logLevel: "info",
    bundle: true,
    define,
    ...args,
  })
}

await buildNode({})
