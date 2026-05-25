"""Strands calculator agent with AgentCore Runtime integration."""

import os
os.environ["BYPASS_TOOL_CONSENT"] = "true"

from strands import Agent
from strands_tools import calculator
from bedrock_agentcore.runtime import BedrockAgentCoreApp

app = BedrockAgentCoreApp()

@app.entrypoint
def agent_invocation(payload, context):
    """Handler for agent invocation.
    
    Args:
        payload: Request payload containing the prompt
        context: AgentCore context information
    
    Returns:
        dict: Response containing the agent's result
    """
    # Extract prompt from payload
    user_message = payload.get("prompt", "No prompt provided")
    
    # Create agent with built-in calculator tool
    agent = Agent(tools=[calculator])
    
    # Process the request
    result = agent(user_message)
    
    # Return structured response
    return {"result": result.message}

if __name__ == "__main__":
    app.run()
