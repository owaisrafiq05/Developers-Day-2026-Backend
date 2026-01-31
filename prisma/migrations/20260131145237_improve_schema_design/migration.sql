-- CreateEnum
CREATE TYPE "AppRole" AS ENUM ('PARTICIPANT', 'STAFF', 'ADMIN', 'TREASURER', 'PR', 'GR', 'FOODFEST');

-- CreateEnum
CREATE TYPE "RegistrationStatus" AS ENUM ('PENDING_PAYMENT', 'VERIFIED', 'REJECTED');

-- CreateEnum
CREATE TYPE "AttendanceMethod" AS ENUM ('SELF_GEOFENCE', 'STAFF_QR', 'STAFF_SOFT_MARK');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('BANK_TRANSFER', 'EASYPAISA', 'JAZZCASH', 'CARD', 'CASH');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255),
    "role" "AppRole" NOT NULL DEFAULT 'PARTICIPANT',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastLogin" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Participant" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cnic" VARCHAR(15) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "fullName" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(20),
    "institution" VARCHAR(200),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Participant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Competition" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "venueId" TEXT,
    "fee" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "minTeamSize" INTEGER NOT NULL DEFAULT 1,
    "maxTeamSize" INTEGER NOT NULL,
    "capacityLimit" INTEGER NOT NULL,
    "compDay" DATE NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "registrationDeadline" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Competition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "competitionId" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "referenceId" VARCHAR(50) NOT NULL,
    "paymentStatus" "RegistrationStatus" NOT NULL DEFAULT 'PENDING_PAYMENT',
    "paymentProofUrl" VARCHAR(500),
    "paymentMethod" "PaymentMethod",
    "paymentDate" TIMESTAMP(3),
    "declaredTID" VARCHAR(100),
    "amountPaid" DECIMAL(10,2),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeamMember" (
    "id" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "participantId" TEXT NOT NULL,
    "isLeader" BOOLEAN NOT NULL DEFAULT false,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "cardIssued" BOOLEAN NOT NULL DEFAULT false,
    "cardIssuedAt" TIMESTAMP(3),

    CONSTRAINT "TeamMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompetitionAttendance" (
    "id" TEXT NOT NULL,
    "teamId" TEXT NOT NULL,
    "participantId" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "method" "AttendanceMethod" NOT NULL,
    "markedBy" VARCHAR(100),
    "markedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,

    CONSTRAINT "CompetitionAttendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StaffProfile" (
    "id" TEXT NOT NULL,
    "fullName" VARCHAR(100) NOT NULL,
    "nuId" VARCHAR(20) NOT NULL,
    "role" "AppRole" NOT NULL DEFAULT 'STAFF',
    "isApproved" BOOLEAN NOT NULL DEFAULT false,
    "approvedAt" TIMESTAMP(3),
    "assignedBooth" VARCHAR(50),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StaffProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "categoryId" TEXT,
    "description" TEXT,
    "website" VARCHAR(255),
    "contactEmail" VARCHAR(255),
    "contactPhone" VARCHAR(20),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FoodStall" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "stallName" VARCHAR(100) NOT NULL,
    "menuDetails" TEXT,
    "paymentStatus" "RegistrationStatus" NOT NULL DEFAULT 'PENDING_PAYMENT',
    "stallLocation" VARCHAR(100),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FoodStall_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrandAmbassador" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fullName" VARCHAR(100) NOT NULL,
    "institute" VARCHAR(200) NOT NULL,
    "referralCode" VARCHAR(20) NOT NULL,
    "totalReferrals" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BrandAmbassador_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Venue" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "location" VARCHAR(200),
    "capacity" INTEGER,
    "facilities" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Venue_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_role_idx" ON "User"("role");

-- CreateIndex
CREATE UNIQUE INDEX "Participant_userId_key" ON "Participant"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Participant_cnic_key" ON "Participant"("cnic");

-- CreateIndex
CREATE UNIQUE INDEX "Participant_email_key" ON "Participant"("email");

-- CreateIndex
CREATE INDEX "Participant_cnic_idx" ON "Participant"("cnic");

-- CreateIndex
CREATE INDEX "Participant_email_idx" ON "Participant"("email");

-- CreateIndex
CREATE INDEX "Competition_compDay_idx" ON "Competition"("compDay");

-- CreateIndex
CREATE INDEX "Competition_isActive_idx" ON "Competition"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Team_referenceId_key" ON "Team"("referenceId");

-- CreateIndex
CREATE INDEX "Team_competitionId_idx" ON "Team"("competitionId");

-- CreateIndex
CREATE INDEX "Team_paymentStatus_idx" ON "Team"("paymentStatus");

-- CreateIndex
CREATE INDEX "Team_referenceId_idx" ON "Team"("referenceId");

-- CreateIndex
CREATE INDEX "TeamMember_teamId_idx" ON "TeamMember"("teamId");

-- CreateIndex
CREATE INDEX "TeamMember_participantId_idx" ON "TeamMember"("participantId");

-- CreateIndex
CREATE UNIQUE INDEX "TeamMember_teamId_participantId_key" ON "TeamMember"("teamId", "participantId");

-- CreateIndex
CREATE INDEX "CompetitionAttendance_teamId_idx" ON "CompetitionAttendance"("teamId");

-- CreateIndex
CREATE INDEX "CompetitionAttendance_participantId_idx" ON "CompetitionAttendance"("participantId");

-- CreateIndex
CREATE INDEX "CompetitionAttendance_markedAt_idx" ON "CompetitionAttendance"("markedAt");

-- CreateIndex
CREATE UNIQUE INDEX "CompetitionAttendance_teamId_participantId_key" ON "CompetitionAttendance"("teamId", "participantId");

-- CreateIndex
CREATE UNIQUE INDEX "StaffProfile_nuId_key" ON "StaffProfile"("nuId");

-- CreateIndex
CREATE INDEX "StaffProfile_nuId_idx" ON "StaffProfile"("nuId");

-- CreateIndex
CREATE INDEX "StaffProfile_isApproved_idx" ON "StaffProfile"("isApproved");

-- CreateIndex
CREATE UNIQUE INDEX "Company_userId_key" ON "Company"("userId");

-- CreateIndex
CREATE INDEX "Company_categoryId_idx" ON "Company"("categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "FoodStall_userId_key" ON "FoodStall"("userId");

-- CreateIndex
CREATE INDEX "FoodStall_paymentStatus_idx" ON "FoodStall"("paymentStatus");

-- CreateIndex
CREATE UNIQUE INDEX "BrandAmbassador_userId_key" ON "BrandAmbassador"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "BrandAmbassador_referralCode_key" ON "BrandAmbassador"("referralCode");

-- CreateIndex
CREATE INDEX "BrandAmbassador_referralCode_idx" ON "BrandAmbassador"("referralCode");

-- CreateIndex
CREATE UNIQUE INDEX "Category_name_key" ON "Category"("name");

-- AddForeignKey
ALTER TABLE "Participant" ADD CONSTRAINT "Participant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Competition" ADD CONSTRAINT "Competition_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_competitionId_fkey" FOREIGN KEY ("competitionId") REFERENCES "Competition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamMember" ADD CONSTRAINT "TeamMember_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamMember" ADD CONSTRAINT "TeamMember_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "Participant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompetitionAttendance" ADD CONSTRAINT "CompetitionAttendance_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompetitionAttendance" ADD CONSTRAINT "CompetitionAttendance_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "Participant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StaffProfile" ADD CONSTRAINT "StaffProfile_id_fkey" FOREIGN KEY ("id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FoodStall" ADD CONSTRAINT "FoodStall_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrandAmbassador" ADD CONSTRAINT "BrandAmbassador_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
