/**
 * @jest-environment jsdom
 */

import { Application } from '@hotwired/stimulus'
import helloController from 'controllers/hello_controller'

describe('hello_controller', () => {
  beforeAll(() => {
    const application = Application.start()
    application.register('hello', helloController)
  })

  describe('controller present', () => {
    let controllerElement;
    let controllerElementId = 'controller-element'

    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="hello" id='${controllerElementId}'></div>
      `
      controllerElement = document.getElementById(controllerElementId)
    })

    describe('#connect', () => {
      it('text injected', () => {
        expect(controllerElement.innerHTML).toContain("Hello World!")
      })
    })

    // To test sharding
    describe('#connect', () => {
      it('text injected 2', () => {
        expect(controllerElement.innerHTML).toContain("Hello World!")
      })
    })

    describe('#connect', () => {
      it('text injected 3', () => {
        expect(controllerElement.innerHTML).toContain("Hello World!")
      })
    })

    describe('#connect', () => {
      it('text injected 4', () => {
        expect(controllerElement.innerHTML).toContain("Hello World!")
      })
    })

    describe('#connect', () => {
      it('text injected 5', () => {
        expect(controllerElement.innerHTML).toContain("Hello World!")
      })
    })
  })
})
