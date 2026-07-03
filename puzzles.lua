return {
    {
        Title        = "Test",
        Prompt       = "This is a test puzzle, can you figure it out?",
        Answer_Check = function(answer)
            answer = tostring(answer)
            return answer == "Hello World!"
        end,
        Max_Attempts = 3
    }
}