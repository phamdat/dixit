package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.START_GAME)
public class StartGame extends BaseDTO {
    public int hostId;

    public static StartGame createResponse(int hostId) {
	StartGame c = new StartGame();
	c.setHostId(hostId);
	return c;
    }

    public int getHostId() {
	return hostId;
    }

    public void setHostId(int hostId) {
	this.hostId = hostId;
    }

}
