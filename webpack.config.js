const path = require("path")
const webpack = require("webpack")

module.exports = {
    mode: "production",
    devtool: "source-map",
    entry: {
        application: "./app/javascript/application.js",
        gallery: "./app/javascript/gallery.js"
    },
    output: {
        filename: "[name].js",
        sourceMapFilename: "[name].js.map",
        path: path.resolve(__dirname, "app/assets/builds"),
    },
    plugins: [
        new webpack.optimize.LimitChunkCountPlugin({
            maxChunks: 1
        }),
        new webpack.ProvidePlugin({
            $: "jquery",
            jQuery: "jquery"
        })
    ],
    module: {
        rules: [
            {
                test: /\.css$/,
                use : [
                    {
                        loader: 'style-loader',
                    },
                    {
                        loader: 'css-loader',
                        options: {
                            sourceMap: true,
                        }
                    }
                ]
            }
        ]
    },

}
