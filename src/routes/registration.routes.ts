import { Router } from 'express'
import { requireAuth } from '../middleware/auth'
import { requireAction } from '../middleware/permission'
import {
    listCompetitions,
    listRegistrations,
    getRegistration,
} from '../controllers/registration.controller'

const router = Router()

router.get(
    '/competitions',
    requireAuth,
    requireAction('VIEW_REGISTRATION_DETAILS'),
    listCompetitions
)

// GET /registrations
router.get(
    '/',
    requireAuth,
    requireAction('VIEW_REGISTRATION_DETAILS'),
    listRegistrations
)

// GET /registrations/:id
router.get(
    '/:id',
    requireAuth,
    requireAction('VIEW_REGISTRATION_DETAILS'),
    getRegistration
)

export default router
