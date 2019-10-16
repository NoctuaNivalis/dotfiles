#!/usr/bin/env python3

async def mute(ui, days):
	from datetime import date, timedelta
	datestr = str(date.today() + timedelta(days=days))
	await ui.apply_commandline(f'toggletags inbox,muted,muted/{datestr}')

async def spam(ui):
	from alot.buffers import EnvelopeBuffer
	from alot.db.envelope import Envelope
	message = ui.current_buffer.get_selected_message()
	message.add_tags(['spam'])
	message.remove_tags(['unread'])
	envelope = Envelope(
		headers=dict(
			From=['Felix Van der Jeugt <felix.vanderjeugt@ugent.be>'],
			To=['spam@ugent.be'],
			Subject=['spam'],
			References=['<' + message.get_message_id() + '>']),
		bodytext='spam',
		tags=['spam'])
	envelope.attach(message.get_filename())
	ui.buffer_open(EnvelopeBuffer(ui, envelope))
