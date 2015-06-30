package com.bap.app.dixit;

public class Test {
	// A scheduler for sending messages shared among all client bots.
	private static ScheduledExecutorService sched = new ScheduledThreadPoolExecutor(1);
	private static final int TOT_PUB_MESSAGES = 50;

	private SmartFox sfs;
	private ConfigData cfg;
	private IEventListener evtListener;
	private ScheduledFuture<?> publicMessageTask;
	private int pubMessageCount = 0;

	@Override
	public void startUp() {
		sfs = new SmartFox();
		cfg = new ConfigData();
		evtListener = new SFSEventListener();

		cfg.setHost("localhost");
		cfg.setPort(9933);
		cfg.setZone("BasicExamples");

		sfs.addEventListener(SFSEvent.CONNECTION, evtListener);
		sfs.addEventListener(SFSEvent.CONNECTION_LOST, evtListener);
		sfs.addEventListener(SFSEvent.LOGIN, evtListener);
		sfs.addEventListener(SFSEvent.ROOM_JOIN, evtListener);
		sfs.addEventListener(SFSEvent.PUBLIC_MESSAGE, evtListener);

		sfs.connect(cfg);
	}

	public class SFSEventListener implements IEventListener {
		@Override
		public void dispatch(BaseEvent evt) throws SFSException {
			String type = evt.getType();
			Map<String, Object> params = evt.getArguments();

			if (type.equals(SFSEvent.CONNECTION)) {
				boolean success = (Boolean) params.get("success");

				if (success)
					sfs.send(new LoginRequest(""));
				else {
					System.err.println("Connection failed");
					cleanUp();
				}
			}

			else if (type.equals(SFSEvent.CONNECTION_LOST)) {
				System.out.println("Client disconnected. ");
				cleanUp();
			}

			else if (type.equals(SFSEvent.LOGIN)) {
				// Join room
				sfs.send(new JoinRoomRequest("The Lobby"));
			}

			else if (type.equals(SFSEvent.ROOM_JOIN)) {
				publicMessageTask = sched.scheduleAtFixedRate(new Runnable() {
					@Override
					public void run() {
						if (pubMessageCount < TOT_PUB_MESSAGES) {
							sfs.send(new PublicMessageRequest("Hello, this is a test public message."));
							pubMessageCount++;

							System.out.println(sfs.getMySelf().getName() + " --> Message: " + pubMessageCount);
						} else {
							// End of test
							sfs.disconnect();
						}

					}
				}, 0, 2, TimeUnit.SECONDS);
			}

		}
	}
}
