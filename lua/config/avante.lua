require('avante_lib').load()

require('avante').setup({
    provider = "kimi",
    providers = {
        ["kimi"] = {
            __inherited_from = "openai",
            endpoint = "https://integrate.api.nvidia.com/v1",
            model = "moonshotai/kimi-k2.5",
            api_key_name = "NVIDIA_API_KEY",
        },
    },
    behaviour = {
        auto_suggestions = false,
    },
})

require('render-markdown').setup({
    file_types = { "markdown", "Avante" }
})
