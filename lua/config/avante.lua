require('avante_lib').load()

require('avante').setup({
    provider = "qwen",
    providers = {
        ["qwen"] = {
            __inherited_from = "openai",
            endpoint = "https://integrate.api.nvidia.com/v1",
            -- model = "qwen/qwen3.5-397b-a17b",
            model = "qwen/qwen3.5-122b-a10b",
            api_key_name = "NVIDIA_API_KEY",
        },
        -- ["moonshot"] = {
        --     __inherited_from = "openai",
        --     endpoint = "https://integrate.api.nvidia.com/v1",
        --     model = "moonshotai/kimi-k2.5",
        --     api_key_name = "NVIDIA_API_KEY",
        -- },

        -- ["minimaxai"] = {
        --     __inherited_from = "openai",
        --     endpoint = "https://integrate.api.nvidia.com/v1",
        --     model = "minimaxai/minimax-m2.7",
        --     api_key_name = "NVIDIA_API_KEY",
        -- },
    },

    behaviour = {
        auto_suggestions = false,
    },
})

require('render-markdown').setup({
    file_types = { "markdown", "Avante" }
})
