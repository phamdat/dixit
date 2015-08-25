package com.bap.app.dixit.dto;

import com.bap.app.dixit.annotation.RequestHandler;
import com.bap.app.dixit.util.Constants;

@RequestHandler(Constants.RequestHandler.START_NEW_TURN)
public class StartNewTurn extends BaseDTO {
    public int hostId;

    public static StartNewTurn createResponse(int hostId) {
	StartNewTurn c = new StartNewTurn();
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
