import { Application } from '@hotwired/stimulus'
import Lightbox from 'stimulus-lightbox'

const application = Application.start()
application.register('lightbox', Lightbox)