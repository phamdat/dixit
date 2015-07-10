package com.bap.app.dixit.util;

public class Constants {

    public static class RequestHandler {
	public static final String START_GAME = "start_game";
	public static final String DRAW_CARD = "draw_card";
	public static final String HOST_SELECT_CARD = "host_select_card";
	public static final String GUEST_SELECT_CARD = "guest_select_card";
	public static final String GUEST_SELECTED_CARD = "guest_selected_card";
	public static final String SELECTED_CARD = "selected_card";
	public static final String GUEST_GUESS_CARD = "guest_guess_card";
	public static final String RETURN_SCORE = "return_score";
    }

    public static class Game {
	public static final int NUM_OF_CARD = 6;
    }

    public static class Error {
	public static final String INTERNAL_SERVER_ERROR = "internal_server_error";
    }

    public static class GameState {
	public static final int START_GAME = 1;
	public static final int DRAW_CARD = 2;
	public static final int HOST_SELECT_CARD = 3;
	public static final int GUEST_SELECT_CARD = 4;
	public static final int GUEST_GUESS_CARD = 5;
	public static final int RETURN_SCORE = 6;
    }
}
