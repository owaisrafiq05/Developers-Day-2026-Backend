import { Response } from 'express'
import { AuthRequest } from '../middleware/auth'
import { prisma } from '../config/db'
import { Prisma, RegistrationStatus } from '@prisma/client'

// GET /registrations/competitions 

export async function listCompetitions(_req: AuthRequest, res: Response): Promise<void> {
    const competitions = await prisma.competition.findMany({
        select: { id: true, name: true, compDay: true, minTeamSize: true, maxTeamSize: true },
        orderBy: { name: 'asc' },
    })
    res.json({ success: true, data: competitions })
}

//  GET /registrations 
// Query params: page, limit, search (name/referenceId/email), competitionId, status

export async function listRegistrations(req: AuthRequest, res: Response): Promise<void> {
    const page  = Math.max(1, parseInt(req.query.page  as string) || 1)
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit as string) || 20))
    const skip  = (page - 1) * limit

    const search        = (req.query.search        as string)?.trim() ?? ''
    const competitionId = (req.query.competitionId as string)?.trim() || undefined
    const statusParam   = (req.query.status        as string)?.trim() || undefined

    // Build where clause
    const where: Prisma.TeamWhereInput = {}

    if (search) {
        where.OR = [
            { name:        { contains: search, mode: 'insensitive' } },
            { referenceId: { contains: search, mode: 'insensitive' } },
        ]
    }

    if (competitionId) {
        where.competitionId = competitionId
    }

    if (statusParam && Object.values(RegistrationStatus).includes(statusParam as RegistrationStatus)) {
        where.paymentStatus = statusParam as RegistrationStatus
    }

    const [total, teams] = await Promise.all([
        prisma.team.count({ where }),
        prisma.team.findMany({
            where,
            skip,
            take: limit,
            orderBy: { createdAt: 'desc' },
            include: {
                competition: { select: { id: true, name: true, compDay: true, fee: true } },
                _count:      { select: { members: true } },
            },
        }),
    ])

    res.json({
        success: true,
        data: teams.map((t) => ({
            id:            t.id,
            name:          t.name,
            referenceId:   t.referenceId,
            paymentStatus: t.paymentStatus,
            paymentMethod: t.paymentMethod,
            competition:   t.competition,
            memberCount:   t._count.members,
            createdAt:     t.createdAt,
        })),
        meta: {
            total,
            page,
            limit,
            totalPages: Math.ceil(total / limit),
        },
    })
}

// GET /registrations/:id 

export async function getRegistration(req: AuthRequest, res: Response): Promise<void> {
    const id = String(req.params.id)

    const team = await prisma.team.findUnique({
        where: { id },
        include: {
            competition: true,
            members: {
                include: {
                    participant: {
                        select: {
                            id:          true,
                            fullName:    true,
                            email:       true,
                            cnic:        true,
                            phone:       true,
                            institution: true,
                        },
                    },
                },
                orderBy: { isLeader: 'desc' },
            },
        },
    })

    if (!team) {
        res.status(404).json({ success: false, message: 'Registration not found.' })
        return
    }

    res.json({
        success: true,
        data: {
            id:              team.id,
            name:            team.name,
            referenceId:     team.referenceId,
            paymentStatus:   team.paymentStatus,
            paymentMethod:   team.paymentMethod,
            paymentDate:     team.paymentDate,
            declaredTID:     team.declaredTID,
            amountPaid:      team.amountPaid ? String(team.amountPaid) : null,
            paymentProofUrl: team.paymentProofUrl,
            createdAt:       team.createdAt,
            updatedAt:       team.updatedAt,
            competition:     team.competition,
            members: team.members.map((m) => ({
                id:          m.id,
                isLeader:    m.isLeader,
                cardIssued:  m.cardIssued,
                cardIssuedAt: m.cardIssuedAt,
                joinedAt:    m.joinedAt,
                participant: m.participant,
            })),
        },
    })
}
